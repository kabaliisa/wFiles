( function _Partial_s_() {

'use strict';

// if( typeof module !== 'undefined' )
// {
//
//   require( '../FileMid.s' );
//
// }

var _ = wTools;
_.assert( !_.FileProvider.wFileProviderPartial );

//

/**
  * Definitions :
  *  Terminal file :: leaf of filesTree, contains series of bytes. Terminal file cant contain other files.
  *  Directory :: non-leaf node of filesTree, contains other directories and terminal file(s).
  *  File :: any node of filesTree, could be leaf( terminal file ) or non-leaf( directory ).
  *  Only terminal files contains series of bytes, function of directory to organize logical space for terminal files.
  *  self :: current object.
  *  Self :: current class.
  *  Parent :: parent class.
  *  Statics :: static fields.
  *  extend :: extend destination with all properties from source.
  */

//

var _ = wTools;
var Parent = _.FileProvider.Abstract;
var Self = function wFileProviderPartial( o )
{
  if( !( this instanceof Self ) )
  if( o instanceof Self )
  return o;
  else
  return new( _.routineJoin( Self, Self, arguments ) );
  return Self.prototype.init.apply( this,arguments );
}

Self.nameShort = 'Partial';

//

function init( o )
{
  var self = this;

  Parent.prototype.init.call( self );

  _.instanceInit( self );

  if( self.Self === Self )
  Object.preventExtensions( self );

  if( o )
  self.copy( o );

  if( self.verbosity )
  self.logger.log( 'new',_.strTypeOf( self ) );

}

// --
// path
// --

function localFromUrl( url )
{
  var self = this;

  if( _.strIs( url ) )
  url = _.urlParse( url );

  _.assert( arguments.length === 1 );
  _.assert( _.mapIs( url ) ) ;
  _.assert( url.localPath );

  return url.localPath;
}

//

function urlFromLocal( localPath )
{
  var self = this;

  debugger;

  _.assert( arguments.length === 1 );
  _.assert( _.strIs( localPath ) )
  _.assert( _.pathIsAbsolute( localPath ) );
  _.assert( self.originPath );

  return self.originPath + localPath;
}

// --
// etc
// --

function _providerOptions( o )
{
  var self = this;

  for( var k in o )
  {
    if( providerDefaults.indexOf( k ) !== -1 )
    if( o[ k ] === null )
    if( self[ k ] !== undefined )
    o[ k ] = self[ k ];
  }
}

//

/**
 * Return options for file read/write. If `filePath is an object, method returns it. Method validate result option
    properties by default parameters from invocation context.
 * @param {string|Object} filePath
 * @param {Object} [o] Object with default options parameters
 * @returns {Object} Result options
 * @private
 * @throws {Error} If arguments is missed
 * @throws {Error} If passed extra arguments
 * @throws {Error} If missed `PathFiile`
 * @method _fileOptionsGet
 * @memberof FileProvider.Partial
 */

function _fileOptionsGet( filePath,o )
{
  var self = this;
  var o = o || {};

  if( _.objectIs( filePath ) )
  {
    o = filePath;
  }
  else
  {
    o.filePath = filePath;
  }

  if( !o.filePath )
  throw _.err( '_fileOptionsGet :','expects (-o.filePath-)' );

  _.assertMapHasOnly( o,this.defaults );
  _.assert( arguments.length === 1 || arguments.length === 2 );

  if( o.sync === undefined )
  o.sync = 1;

  return o;
}

//

function fileRecord( filePath,o )
{
  var self = this;

  if( filePath instanceof _.FileRecord && arguments[ 1 ] === undefined && filePath.fileProvider === self )
  return filePath

  _.assert( _.strIs( filePath ),'expects string ( filePath ), but got',_.strTypeOf( filePath ) );
  _.assert( arguments.length === 1 || arguments.length === 2 );

  if( o === undefined )
  o = Object.create( null );

  if( !( o instanceof _.FileRecordOptions ) )
  o.fileProvider = self;

  _.assert( o.fileProvider === self );

  return _.FileRecord( filePath,o );
}

var having = fileRecord.having = Object.create( null );

having.writing = 0;
having.reading = 1;
having.record = 1;
having.bare = 0;

//

function fileRecords( filePaths,o )
{
  var self = this;

  if( _.strIs( filePaths ) || filePaths instanceof _.FileRecord )
  filePaths = [ filePaths ];

  _.assert( _.arrayIs( filePaths ),'expects array ( filePaths ), but got',_.strTypeOf( filePaths ) );
  _.assert( arguments.length === 1 || arguments.length === 2 );

  var result = [];

  for( var r = 0 ; r < filePaths.length ; r++ )
  result[ r ] = self.fileRecord( filePaths[ r ],o );

  return result;
}

var having = fileRecords.having = Object.create( null );

having.writing = 0;
having.reading = 1;
having.record = 1;
having.bare = 0;

//

function fileRecordsFiltered( filePaths,o )
{
  var self = this;
  var result = self.fileRecords( filePaths,o );

  for( var r = result.length-1 ; r >= 0 ; r-- )
  if( !result[ r ].inclusion )
  result.splice( r,1 );

  return result;
}

var having = fileRecordsFiltered.having = Object.create( null );

having.writing = 0;
having.reading = 1;
having.record = 1;
having.bare = 0;

// --
// adapter
// --

function pathNativize( filePath )
{
  var self = this;
  _.assert( _.strIs( filePath ) ) ;
  return filePath;
}

var pathsNativize = _.routineInputMultiplicator_functor( 'pathNativize' );

var having = pathNativize.having = Object.create( null );

having.writing = 0;
having.reading = 0;
having.bare = 0;

// --
// read act
// --

var fileReadAct = {};
fileReadAct.defaults =
{
  sync : null,
  filePath : null,
  encoding : 'utf8',
  advanced : null,
}

var having = fileReadAct.having = Object.create( null );

having.writing = 0;
having.reading = 1;
having.bare = 1;

//

var fileReadStreamAct = {};
fileReadStreamAct.defaults =
{
  filePath : null,
}

var having = fileReadStreamAct.having = Object.create( null );

having.writing = 0;
having.reading = 1;
having.bare = 1;

//

var fileStatAct = {};
fileStatAct.defaults =
{
  filePath : null,
  sync : null,
  throwing : 0,
  resolvingSoftLink : null,
}

var having = fileStatAct.having = Object.create( null );

having.writing = 0;
having.reading = 1;
having.bare = 1;

//

var fileHashAct = {};
fileHashAct.defaults =
{
  filePath : null,
  sync : null,
  throwing : 0
}

var having = fileHashAct.having = Object.create( null );

having.writing = 0;
having.reading = 1;
having.bare = 1;

//

var directoryReadAct = {};
directoryReadAct.defaults =
{
  filePath : null,
  sync : null,
  throwing : 0
}

var having = directoryReadAct.having = Object.create( null );

having.writing = 0;
having.reading = 1;
having.bare = 1;

// --
// read content
// --

/**
 * Reads the entire content of a file.
 * Can accepts `filePath` as first parameters and options as second
 * Returns wConsequence instance. If `o` sync parameter is set to true (by default) and returnRead is set to true,
    method returns encoded content of a file.
 * There are several way to get read content : as argument for function passed to wConsequence.got(), as second argument
    for `o.onEnd` callback, and as direct method returns, if `o.returnRead` is set to true.
 *
 * @example
 * // content of tmp/json1.json : {"a" :1,"b" :"s","c" :[1,3,4]}
   var fileReadOptions =
   {
     sync : 0,
     filePath : 'tmp/json1.json',
     encoding : 'json',

     onEnd : function( err, result )
     {
       console.log(result); // { a : 1, b : 's', c : [ 1, 3, 4 ] }
     }
   };

   var con = wTools.fileRead( fileReadOptions );

   // or
   fileReadOptions.onEnd = null;
   var con2 = wTools.fileRead( fileReadOptions );

   con2.got(function( err, result )
   {
     console.log(result); // { a : 1, b : 's', c : [ 1, 3, 4 ] }
   });

 * @example
   fileRead({ filePath : file.absolute, encoding : 'buffer-node' })

 * @param {Object} o read options
 * @param {string} o.filePath path to read file
 * @param {boolean} [o.sync=true] determines in which way will be read file. If this set to false, file will be read
    asynchronously, else synchronously
 * Note : if even o.sync sets to true, but o.returnRead if false, method will resolve read content through wConsequence
    anyway.
 * @param {boolean} [o.wrap=false] If this parameter sets to true, o.onBegin callback will get `o` options, wrapped
    into object with key 'options' and options as value.
 * @param {boolean} [o.returnRead=false] If sets to true, method will return encoded file content directly. Has effect
    only if o.sync is set to true.
 * @param {boolean} [o.silent=false] If set to true, method will caught errors occurred during read file process, and
    pass into o.onEnd as first parameter. Note : if sync is set to false, error will caught anyway.
 * @param {string} [o.name=null]
 * @param {string} [o.encoding='utf8'] Determines encoding processor. The possible values are :
 *    'utf8' : default value, file content will be read as string.
 *    'json' : file content will be parsed as JSON.
 *    'arrayBuffer' : the file content will be return as raw ArrayBuffer.
 * @param {fileRead~onBegin} [o.onBegin=null] @see [@link fileRead~onBegin]
 * @param {Function} [o.onEnd=null] @see [@link fileRead~onEnd]
 * @param {Function} [o.onError=null] @see [@link fileRead~onError]
 * @param {*} [o.advanced=null]
 * @returns {wConsequence|ArrayBuffer|string|Array|Object}
 * @throws {Error} if missed arguments
 * @throws {Error} if `o` has extra parameters
 * @method fileRead
 * @memberof FileProvider.Partial
 */

/**
 * This callback is run before fileRead starts read the file. Accepts error as first parameter.
 * If in fileRead passed 'o.wrap' that is set to true, callback accepts as second parameter object with key 'options'
    and value that is reference to options object passed into fileRead method, and user has ability to configure that
    before start reading file.
 * @callback fileRead~onBegin
 * @param {Error} err
 * @param {Object|*} options options argument passed into fileRead.
 */

/**
 * This callback invoked after file has been read, and accepts encoded file content data (by depend from
    options.encoding value), string by default ('utf8' encoding).
 * @callback fileRead~onEnd
 * @param {Error} err Error occurred during file read. If read success it's sets to null.
 * @param {ArrayBuffer|Object|Array|String} result Encoded content of read file.
 */

/**
 * Callback invoke if error occurred during file read.
 * @callback fileRead~onError
 * @param {Error} error
 */

function fileRead( o )
{
  var self = this;
  var result = null;

  if( _.strIs( o ) )
  o = { filePath : o };

  if( o.returnRead === undefined )
  o.returnRead = o.sync !== undefined && o.sync !== null ? o.sync : self.sync;

  // _.mapComplement( o,fileRead.defaults );
  _.routineOptions( fileRead, o );
  self._providerOptions( o );

  _.assert( !o.returnRead || o.sync,'cant return read for async read' );
  if( o.sync )
  _.assert( o.returnRead,'sync expects ( returnRead == 1 )' );

  var encoder = fileRead.encoders[ o.encoding ];

  /* begin */

  function handleBegin()
  {

    if( encoder && encoder.onBegin )
    encoder.onBegin.call( self,{ transaction : o, encoder : encoder });

    if( !o.onBegin )
    return;

    var r;
    if( o.wrap )
    r = { options : o };
    else
    r = o;

    // debugger;
    wConsequence.give( o.onBegin,r );
  }

  /* end */

  function handleEnd( data )
  {

    if( encoder && encoder.onEnd )
    data = encoder.onEnd.call( self,{ data : data, transaction : o, encoder : encoder });

    var r;
    if( o.wrap )
    r = { data : data, options : o };
    else
    r = data;

    if( o.onEnd )
    wConsequence.give( o.onEnd,r );
    // if( !o.sync )
    // wConsequence.give( result,r );

    return r;
  }

  /* error */

  function handleError( err )
  {

    if( encoder && encoder.onError )
    try
    {
      err = _._err
      ({
        args : [ stack,'\nfileReadAct( ',o.filePath,' )\n',err ],
        usingSourceCode : 0,
        level : 0,
      });
      err = encoder.onError.call( self,{ error : err, transaction : o, encoder : encoder })
    }
    catch( err2 )
    {
      console.error( err2 );
      console.error( err );
    }

    if( o.onError )
    wConsequence.error( o.onError,err );

    if( o.throwing )
    throw _.err( err );

  }

  /* exec */

  // if( o.encoding !== 'json' )
  // debugger;

  handleBegin();

  var optionsRead = _.mapScreen( self.fileReadAct.defaults,o );
  optionsRead.filePath = self.pathNativize( optionsRead.filePath );

  try
  {
    result = self.fileReadAct( optionsRead );
  }
  catch( err )
  {
    if( o.sync )
    result = err;
    else
    result = new wConsequence().error( err );
  }

  /* throwing */

  if( o.sync )
  {
    if( _.errIs( result ) )
    return handleError( result );
    return handleEnd( result );
  }
  else
  {

    result
    .ifNoErrorThen( handleEnd )
    .ifErrorThen( handleError )
    ;

    return result;
  }

  /* return */

  return handleEnd( result );
}

fileRead.defaults =
{
  wrap : 0,
  returnRead : 0,
  throwing : null,

  name : null,

  onBegin : null,
  onEnd : null,
  onError : null,

  advanced : null,
}

fileRead.defaults.__proto__ = fileReadAct.defaults;

fileRead.having =
{
  bare : 0
}

fileRead.having.__proto__ = fileReadAct.having;

//

function fileReadStream( o )
{
  var self = this;

  if( _.strIs( o ) )
  o = { filePath : o };

  _.assert( arguments.length === 1 );
  _.assert( _.strIs( o.filePath ) );

  _.routineOptions( fileReadStream, o );

  var optionsRead = _.mapExtend( Object.create( null ), o );
  optionsRead.filePath = self.pathNativize( optionsRead.filePath );

  return self.fileReadStreamAct( optionsRead );
}

fileReadStream.defaults = {};

fileReadStream.defaults.__proto__ = fileReadStreamAct.defaults;

fileReadStream.having =
{
  bare : 0
};

fileReadStream.having.__proto__ = fileReadStreamAct.having;

//

/**
 * Reads the entire content of a file synchronously.
 * Method returns encoded content of a file.
 * Can accepts `filePath` as first parameters and options as second
 *
 * @example
 * // content of tmp/json1.json : { "a" : 1, "b" : "s", "c" : [ 1,3,4 ]}
 var fileReadOptions =
 {
   filePath : 'tmp/json1.json',
   encoding : 'json',

   onEnd : function( err, result )
   {
     console.log(result); // { a : 1, b : 's', c : [ 1, 3, 4 ] }
   }
 };

 var res = wTools.fileReadSync( fileReadOptions );
 // { a : 1, b : 's', c : [ 1, 3, 4 ] }

 * @param {Object} o read options
 * @param {string} o.filePath path to read file
 * @param {boolean} [o.wrap=false] If this parameter sets to true, o.onBegin callback will get `o` options, wrapped
 into object with key 'options' and options as value.
 * @param {boolean} [o.silent=false] If set to true, method will caught errors occurred during read file process, and
 pass into o.onEnd as first parameter. Note : if sync is set to false, error will caught anyway.
 * @param {string} [o.name=null]
 * @param {string} [o.encoding='utf8'] Determines encoding processor. The possible values are :
 *    'utf8' : default value, file content will be read as string.
 *    'json' : file content will be parsed as JSON.
 *    'arrayBuffer' : the file content will be return as raw ArrayBuffer.
 * @param {fileRead~onBegin} [o.onBegin=null] @see [@link fileRead~onBegin]
 * @param {Function} [o.onEnd=null] @see [@link fileRead~onEnd]
 * @param {Function} [o.onError=null] @see [@link fileRead~onError]
 * @param {*} [o.advanced=null]
 * @returns {wConsequence|ArrayBuffer|string|Array|Object}
 * @throws {Error} if missed arguments
 * @throws {Error} if `o` has extra parameters
 * @method fileReadSync
 * @memberof wTools
 */

function fileReadSync()
{
  var self = this;
  var o = self._fileOptionsGet.apply( fileReadSync,arguments );

  _.mapComplement( o,fileReadSync.defaults );
  o.sync = 1;

  //self.logger.log( 'fileReadSync.returnRead : ',o.returnRead );

  return self.fileRead( o );
}

fileReadSync.defaults =
{
  returnRead : 1,
  sync : 1,
  encoding : 'utf8',
}

fileReadSync.defaults.__proto__ = fileRead.defaults;

var having = fileReadSync.having = Object.create( null );

having.writing = 0;
having.reading = 1;
having.bare = 0;

//

/**
 * Reads a JSON file and then parses it into an object.
 *
 * @example
 * // content of tmp/json1.json : {"a" :1,"b" :"s","c" :[1,3,4]}
 *
 * var res = wTools.fileReadJson( 'tmp/json1.json' );
 * // { a : 1, b : 's', c : [ 1, 3, 4 ] }
 * @param {string} filePath file path
 * @returns {*}
 * @throws {Error} If missed arguments, or passed more then one argument.
 * @method fileReadJson
 * @memberof wTools
 */

function fileReadJson( o )
{
  var self = this;
  var result = null;

  if( _.strIs( o ) )
  o = { filePath : o };

  _.assert( arguments.length === 1 );
  _.routineOptions( fileReadJson,o );
  self._providerOptions( o );

  o.filePath = _.pathGet( o.filePath );

  _.assert( arguments.length === 1 );

  if( self.fileStat( o.filePath ) )
  {

    try
    {
      var str = self.fileRead( o );
      result = JSON.parse( str );
    }
    catch( err )
    {
      throw _.err( 'cant read json from',o.filePath,'\n',err );
    }

  }

  return result;
}

fileReadJson.defaults =
{
  encoding : 'utf8',
  sync : 1,
  returnRead : 1,
}

fileReadJson.defaults.__proto__ = fileRead.defaults;

var having = fileReadJson.having = Object.create( null );

having.writing = 0;
having.reading = 1;
having.bare = 0;

//

var fileHash = ( function()
{
  var crypto;

  return function fileHash( o )
  {
    var self = this;

    if( _.strIs( o ) )
    o = { filePath : o };

    o.filePath = self.pathNativize( o.filePath );

    _.routineOptions( fileHash,o );
    self._providerOptions( o );
    _.assert( arguments.length === 1 );
    _.assert( _.strIs( o.filePath ) );

    if( o.verbosity )
    self.logger.log( 'fileHash :',o.filePath );

    if( crypto === undefined )
    crypto = require( 'crypto' );
    var md5sum = crypto.createHash( 'md5' );

    /* */

    if( o.sync )
    {
      var result;
      try
      {
        var read = self.fileReadSync( o.filePath );
        md5sum.update( read );
        result = md5sum.digest( 'hex' );
      }
      catch( err )
      {
        if( o.throwing )
        throw err;
        result = NaN;
      }

      return result;

    }
    else
    {
      var con = new wConsequence();
      var stream = self.fileReadStream( o.filePath );

      stream.on( 'data', function( d )
      {
        md5sum.update( d );
      });

      stream.on( 'end', function()
      {
        var hash = md5sum.digest( 'hex' );
        con.give( hash );
      });

      stream.on( 'error', function( err )
      {
        if( o.throwing )
        con.error( _.err( err ) );
        else
        con.give( NaN );
      });

      return con;
    }
  }

})();

fileHash.defaults =
{
  filePath : null,
  sync : null,
  throwing : 0,
  verbosity : null
}

var having = fileHash.having = Object.create( null );

having.writing = 0;
having.reading = 1;
having.bare = 0;

//

function filesFingerprints( files )
{
  var self = this;

  if( _.strIs( files ) || files instanceof _.FileRecord )
  files = [ files ];

  _.assert( _.arrayIs( files ) || _.mapIs( files ) );

  var result = Object.create( null );

  for( var f = 0 ; f < files.length ; f++ )
  {
    var record = self.fileRecord( files[ f ] );
    var fingerprint = Object.create( null );

    if( !record.inclusion )
    continue;

    fingerprint.size = record.stat.size;
    fingerprint.hash = record.hashGet();

    result[ record.relative ] = fingerprint;
  }

  return result;
}

var having = filesFingerprints.having = Object.create( null );

having.writing = 0;
having.reading = 1;
having.bare = 0;

//

/**
 * Check if two paths, file stats or FileRecords are associated with the same file or files with same content.
 * @example
 * var path1 = 'tmp/sample/file1',
     path2 = 'tmp/sample/file2',
     usingTime = true,
     buffer = new Buffer( [ 0x01, 0x02, 0x03, 0x04 ] );

   wTools.fileWrite( { filePath : path1, data : buffer } );
   setTimeout( function()
   {
     wTools.fileWrite( { filePath : path2, data : buffer } );

     var sameWithoutTime = wTools.filesSame( path1, path2 ); // true

     var sameWithTime = wTools.filesSame( path1, path2, usingTime ); // false
   }, 100);
 * @param {string|wFileRecord} ins1 first file to compare
 * @param {string|wFileRecord} ins2 second file to compare
 * @param {boolean} usingTime if this argument sets to true method will additionally check modified time of files, and
    if they are different, method returns false.
 * @returns {boolean}
 * @method filesSame
 * @memberof wTools
 */

function filesSame( o )
{
  var self = this;

  if( arguments.length === 2 || arguments.length === 3 )
  {
    o =
    {
      ins1 : arguments[ 0 ],
      ins2 : arguments[ 1 ],
      usingTime : arguments[ 2 ],
    }
  }

  _.assert( arguments.length === 1 || arguments.length === 2 || arguments.length === 3 );
  _.assertMapHasOnly( o,filesSame.defaults );
  _.mapSupplement( o,filesSame.defaults );

  //debugger;

  o.ins1 = self.fileRecord( o.ins1 );
  o.ins2 = self.fileRecord( o.ins2 );

  /**/

/*
  if( o.ins1.absolute.indexOf( 'x/x.s' ) !== -1 )
  {
    self.logger.log( '? filesSame : ' + o.ins1.absolute );
    //debugger;
  }
*/

  /**/

  if( o.ins1.stat.isDirectory() )
  throw _.err( o.ins1.absolute,'is directory' );

  if( o.ins2.stat.isDirectory() )
  throw _.err( o.ins2.absolute,'is directory' );

  if( !o.ins1.stat || !o.ins2.stat )
  return false;

  /* symlink */

  if( o.usingSymlink )
  if( o.ins1.stat.isSymbolicLink() || o.ins2.stat.isSymbolicLink() )
  {

    debugger;
    //console.warn( 'filesSame : not tested' );

    return false;
  // return false;

    var target1 = o.ins1.stat.isSymbolicLink() ? File.readlinkSync( o.ins1.absolute ) : o.ins1.absolute;
    var target2 = o.ins2.stat.isSymbolicLink() ? File.readlinkSync( o.ins2.absolute ) : o.ins2.absolute;

    if( target2 === target1 )
    return true;

    o.ins1 = self.fileRecord( target1 );
    o.ins2 = self.fileRecord( target2 );

  }

  /* hard linked */

  _.assert( !( o.ins1.stat.ino < -1 ) );
  if( o.ins1.stat.ino > 0 )
  if( o.ins1.stat.ino === o.ins2.stat.ino )
  return true;

  /* false for empty files */

  if( !o.ins1.stat.size || !o.ins2.stat.size )
  return false;

  /* size */

  if( o.ins1.stat.size !== o.ins2.stat.size )
  return false;

  /* hash */

  if( o.usingHash )
  {

    // self.logger.log( 'o.ins1 :',o.ins1 );

    if( o.ins1.hash === undefined || o.ins1.hash === null )
    o.ins1.hash = self.fileHash( o.ins1.absolute );
    if( o.ins2.hash === undefined || o.ins2.hash === null )
    o.ins2.hash = self.fileHash( o.ins2.absolute );

    if( ( _.numberIs( o.ins1.hash ) && isNaN( o.ins1.hash ) ) || ( _.numberIs( o.ins2.hash ) && isNaN( o.ins2.hash ) ) )
    return o.uncertainty;

    return o.ins1.hash === o.ins2.hash;
  }
  else
  {
    debugger;
    return o.uncertainty;
  }

}

filesSame.defaults =
{
  ins1 : null,
  ins2 : null,
  usingTime : false,
  usingSymlink : false,
  usingHash : true,
  uncertainty : false,
}

var having = filesSame.having = Object.create( null );

having.writing = 0;
having.reading = 1;
having.bare = 0;

//

/**
 * Check if one of paths is hard link to other.
 * @example
   var fs = require('fs');

   var path1 = '/home/tmp/sample/file1',
   path2 = '/home/tmp/sample/file2',
   buffer = new Buffer( [ 0x01, 0x02, 0x03, 0x04 ] );

   wTools.fileWrite( { filePath : path1, data : buffer } );
   fs.symlinkSync( path1, path2 );

   var linked = wTools.filesLinked( path1, path2 ); // true

 * @param {string|wFileRecord} ins1 path string/file record instance
 * @param {string|wFileRecord} ins2 path string/file record instance

 * @returns {boolean}
 * @throws {Error} if missed one of arguments or pass more then 2 arguments.
 * @method filesLinked
 * @memberof wTools
 */

function filesLinked( o )
{
  var self = this;

  if( arguments.length === 2 )
  {
    o =
    {
      ins1 : self.fileRecord( arguments[ 0 ] ),
      ins2 : self.fileRecord( arguments[ 1 ] ),
    }
  }
  else
  {
    _.assert( arguments.length === 1 );
    _.assertMapHasOnly( o, filesLinked.defaults );
  }

  if( o.ins1.stat.isSymbolicLink() || o.ins2.stat.isSymbolicLink() )
  {

    // !!!

    // +++ check links targets
    // +++ use case needed, solution will go into FileRecord, probably

    return false;
    debugger;
    throw _.err( 'not tested' );

/*
    var target1 = ins1.stat.isSymbolicLink() ? File.readlinkSync( ins1.absolute ) : Path.resolve( ins1.absolute ),
      target2 =  ins2.stat.isSymbolicLink() ? File.readlinkSync( ins2.absolute ) : Path.resolve( ins2.absolute );
    return target2 === target1;
*/

  }

  return _.statsAreLinked( o.ins1.stat , o.ins2.stat );

  // /* ino comparison reliable test if ino present */
  // if( o.ins1.stat.ino !== o.ins2.stat.ino ) return false;
  //
  // _.assert( !( o.ins1.stat.ino < -1 ) );
  //
  // // if( o.ins1.stat.ino > 0 )
  // // return o.ins1.stat.ino === o.ins2.stat.ino;
  //
  // /* try to make a good guess otherwise */
  // if( o.ins1.stat.nlink !== o.ins2.stat.nlink ) return false;
  // if( o.ins1.stat.mode !== o.ins2.stat.mode ) return false;
  // if( o.ins1.stat.mtime.getTime() !== o.ins2.stat.mtime.getTime() ) return false;
  // if( o.ins1.stat.ctime.getTime() !== o.ins2.stat.ctime.getTime() ) return false;
  //
  // return true;
}

filesLinked.defaults =
{
  ins1 : null,
  ins2 : null,
}

var having = filesLinked.having = Object.create( null );

having.writing = 0;
having.reading = 1;
having.bare = 0;

//

function directoryRead( o )
{
  var self = this;

  _.assert( arguments.length === 1 );

  if( _.strIs( o ) )
  o = { filePath : o };

  _.assert( _.strIs( o.filePath ) );

  _.routineOptions( directoryRead, o );
  self._providerOptions( o );

  var optionsRead = _.mapExtend( null,o );
  optionsRead.filePath = self.pathNativize( optionsRead.filePath );

  function sort( result )
  {
    if( result )
    result.sort( function( a, b )
    {
      a = a.toLowerCase();
      b = b.toLowerCase();
      if( a < b ) return -1;
      if( a > b ) return +1;
      return 0;
    });
    return result;
  }

  var result = self.directoryReadAct( optionsRead );

  if( optionsRead.sync )
  {
    sort( result );
  }
  else
  {
    result.ifNoErrorThen( function( list )
    {
      return sort( list );
    });
  }

  return result;
}

directoryRead.defaults = {};

directoryRead.defaults.__proto__ = directoryReadAct.defaults;

directoryRead.having =
{
  bare : 0
}

directoryRead.having.__proto__ = directoryReadAct.having;


// --
// read stat
// --

function fileStat( o )
{
  var self = this;

  if( _.strIs( o ) )
  o = { filePath : o };

  _.assert( arguments.length === 1 );
  _.routineOptions( fileStat,o );
  self._providerOptions( o );
  _.assert( _.strIs( o.filePath ) );

  if( o.resolvingTextLink )
  o.filePath = _.pathResolveTextLink( o.filePath, true );

  var optionsStat = _.mapScreen( self.fileStatAct.defaults, o );
  optionsStat.filePath = self.pathNativize( optionsStat.filePath );

  // self.logger.log( 'fileStat' );
  // self.logger.log( o );

  return self.fileStatAct( optionsStat );
}

fileStat.defaults =
{
  resolvingTextLink : null
};

fileStat.defaults.__proto__ = fileStatAct.defaults;

fileStat.having =
{
  bare : 0
}

fileStat.having.__proto__ = fileStatAct.having;

//

/**
 * Returns true if file at ( filePath ) is an existing regular terminal file.
 * @example
 * wTools.fileIsTerminal( './existingDir/test.txt' ); // true
 * @param {string} filePath Path string
 * @returns {boolean}
 * @method fileIsTerminal
 * @memberof wTools
 */

function fileIsTerminal( filePath )
{
  var self = this;

  _.assert( arguments.length === 1 );

  var stat = self.fileStat( filePath );

  if( !stat )
  return false;

  if( stat.isSymbolicLink() )
  {
    console.log( 'fileIsTerminal',filePath );
    // throw _.err( 'not tested' );
    return false;
  }

  return stat.isFile();
}

var having = fileIsTerminal.having = Object.create( null );

having.writing = 0;
having.reading = 1;
having.bare = 0;

//

/**
 * Return True if `filePath` is a symbolic link.
 * @param filePath
 * @returns {boolean}
 * @method fileIsSoftLink
 * @memberof wTools
 */

function fileIsSoftLink( filePath )
{
  var self = this;

  _.assert( arguments.length === 1 );

  var stat = self.fileStat
  ({
    filePath : filePath,
    resolvingSoftLink : 0
  });

  if( !stat )
  return false;

  return stat.isSymbolicLink();
}

var having = fileIsSoftLink.having = Object.create( null );

having.writing = 0;
having.reading = 1;
having.bare = 0;

//

/**
 * Returns sum of sizes of files in `paths`.
 * @example
 * var path1 = 'tmp/sample/file1',
   path2 = 'tmp/sample/file2',
   textData1 = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
   textData2 = 'Aenean non feugiat mauris';

   wTools.fileWrite( { filePath : path1, data : textData1 } );
   wTools.fileWrite( { filePath : path2, data : textData2 } );
   var size = wTools.filesSize( [ path1, path2 ] );
   console.log(size); // 81
 * @param {string|string[]} paths path to file or array of paths
 * @param {Object} [o] additional o
 * @param {Function} [o.onBegin] callback that invokes before calculation size.
 * @param {Function} [o.onEnd] callback.
 * @returns {number} size in bytes
 * @method filesSize
 * @memberof wTools
 */

function filesSize( o )
{
  var self = this;
  var o = o || Object.create( null );

  if( _.strIs( o ) || _.arrayIs( o ) )
  o = { filePath : o };

  _.assert( arguments.length === 1 );

  // throw _.err( 'not tested' );

  var result = 0;
  var o = o || Object.create( null );
  o.filePath = _.arrayAs( o.filePath );

  // if( o.onBegin ) o.onBegin.call( this,null );
  //
  // if( o.onEnd ) throw 'Not implemented';

  for( var p = 0 ; p < o.filePath.length ; p++ )
  {
    var optionsForSize = _.mapExtend( Object.create( null ),o );
    optionsForSize.filePath = o.filePath[ p ];
    result += self.fileSize( optionsForSize );
  }

  return result;
}

var having = filesSize.having = Object.create( null );

having.writing = 0;
having.reading = 1;
having.bare = 0;

//

/**
 * Return file size in bytes. For symbolic links return false. If onEnd callback is defined, method returns instance
    of wConsequence.
 * @example
 * var path = 'tmp/fileSize/data4',
     bufferData1 = new Buffer( [ 0x01, 0x02, 0x03, 0x04 ] ), // size 4
     bufferData2 = new Buffer( [ 0x07, 0x06, 0x05 ] ); // size 3

   wTools.fileWrite( { filePath : path, data : bufferData1 } );

   var size1 = wTools.fileSize( path );
   console.log(size1); // 4

   var con = wTools.fileSize( {
     filePath : path,
     onEnd : function( size )
     {
       console.log( size ); // 7
     }
   } );

   wTools.fileWrite( { filePath : path, data : bufferData2, append : 1 } );

 * @param {string|Object} o o object or path string
 * @param {string} o.filePath path to file
 * @param {Function} [o.onBegin] callback that invokes before calculation size.
 * @param {Function} o.onEnd this callback invoked in end of current js event loop and accepts file size as
    argument.
 * @returns {number|boolean|wConsequence}
 * @throws {Error} If passed less or more than one argument.
 * @throws {Error} If passed unexpected parameter in o.
 * @throws {Error} If filePath is not string.
 * @method fileSize
 * @memberof wTools
 */

function fileSize( o )
{
  var self = this;
  var o = o || Object.create( null );

  // throw _.err( 'not tested' );

  if( _.strIs( o ) )
  o = { filePath : o };

  _.routineOptions( fileSize,o );
  _.assert( arguments.length === 1 );
  _.assert( _.strIs( o.filePath ),'expects string ( o.filePath ), but got',_.strTypeOf( o.filePath ) );

  if( self.fileIsSoftLink( o.filePath ) )
  {
    throw _.err( 'not tested' );
    return false;
  }

  // synchronization

  // if( o.onEnd ) return _.timeOut( 0, function()
  // {
  //   var onEnd = o.onEnd;
  //   delete o.onEnd;
  //   onEnd.call( this,fileSize.call( this,o ) );
  // });
  //
  // if( o.onBegin ) o.onBegin.call( this,null );

  // var stat = File.statSync( o.filePath );
  var stat = self.fileStat( o );

  return stat.size;
}

fileSize.defaults =
{
  filePath : null,
  // onBegin : null,
  // onEnd : null,
}

fileSize.defaults.__proto__ = fileStat.defaults;

var having = fileSize.having = Object.create( null );

having.writing = 0;
having.reading = 1;
having.bare = 0;

//

/**
 * Return True if file at ( filePath ) is an existing directory.
 * If file is symbolic link to file or directory return false.
 * @example
 * wTools.directoryIs( './existingDir/' ); // true
 * @param {string} filePath Tested path string
 * @returns {boolean}
 * @method directoryIs
 * @memberof wTools
 */

function directoryIs( filePath )
{
  var self = this;

  _.assert( arguments.length === 1 );

  var stat = self.fileStat
  ({
    filePath : filePath,
    resolvingSoftLink : self.resolvingSoftLink
  });

  if( !stat )
  return false;

  if( stat.isSymbolicLink() )
  {
    // throw _.err( 'Not tested' );
    return false;
  }

  return stat.isDirectory();
}

var having = directoryIs.having = Object.create( null );

having.writing = 0;
having.reading = 1;
having.bare = 0;
//

/**
 * Returns True if file at ( filePath ) is an existing empty directory, otherwise returns false.
 * If file is symbolic link to file or directory return false.
 * @example
 * wTools.fileProvider.directoryIsEmpty( './existingEmptyDir/' ); // true
 * @param {string} filePath - Path to the directory.
 * @returns {boolean}
 * @method directoryIsEmpty
 * @memberof wTools
 */

function directoryIsEmpty( filePath )
{
  var self = this;

  _.assert( arguments.length === 1 );

  if( self.directoryIs( filePath ) )
  return !self.directoryRead( filePath ).length;

  return false;
}

var having = directoryIsEmpty.having = Object.create( null );

having.writing = 0;
having.reading = 1;
having.bare = 0;

// --
// write act
// --

var fileWriteAct = {};
fileWriteAct.defaults =
{
  filePath : null,
  sync : null,
  data : '',
  writeMode : 'rewrite',
}

var having = fileWriteAct.having = Object.create( null );

having.writing = 1;
having.reading = 0;
having.bare = 1;

//

var fileWriteStreamAct = {};
fileWriteStreamAct.defaults =
{
  filePath : null,
}

var having = fileWriteStreamAct.having = Object.create( null );

having.writing = 1;
having.reading = 0;
having.bare = 1;

//

var fileDeleteAct = {};
fileDeleteAct.defaults =
{

  filePath : null,
  sync : null,

}

var having = fileDeleteAct.having = Object.create( null );

having.writing = 1;
having.reading = 0;
having.bare = 1;

//

var fileTimeSetAct = {};
fileTimeSetAct.defaults =
{

  filePath : null,
  atime : null,
  mtime : null,

}

var having = fileTimeSetAct.having = Object.create( null );

having.writing = 1;
having.reading = 0;
having.bare = 1;

//

var directoryMakeAct = {};
directoryMakeAct.defaults =
{
  filePath : null,
  // force : 0,
  // rewritingTerminal : 0,
  sync : null,
}

var having = directoryMakeAct.having = Object.create( null );

having.writing = 1;
having.reading = 0;
having.bare = 1;

//

// !!! act version should not have advanced options

var fileCopyAct = {};
fileCopyAct.defaults =
{
  dstPath : null,
  srcPath : null,
  sync : null,
}

var having = fileCopyAct.having = Object.create( null );

having.writing = 1;
having.reading = 0;
having.bare = 1;

//

var fileRenameAct = {};
fileRenameAct.defaults =
{
  dstPath : null,
  srcPath : null,
  sync : null,
}

var having = fileRenameAct.having = Object.create( null );

having.writing = 1;
having.reading = 0;
having.bare = 1;

//

var linkSoftAct = {};
linkSoftAct.defaults =
{
  dstPath : null,
  srcPath : null,
  sync : null,
}

var having = linkSoftAct.having = Object.create( null );

having.writing = 1;
having.reading = 0;
having.bare = 1;

//

var linkHardAct = {};
linkHardAct.defaults =
{
  dstPath : null,
  srcPath : null,
  sync : null,
}

var having = linkHardAct.having = Object.create( null );

having.writing = 1;
having.reading = 0;
having.bare = 1;

// --
// write
// --

/**
 * Writes data to a file. `data` can be a string or a buffer. Creating the file if it does not exist yet.
 * Returns wConsequence instance.
 * By default method writes data synchronously, with replacing file if exists, and if parent dir hierarchy doesn't
   exist, it's created. Method can accept two parameters : string `filePath` and string\buffer `data`, or single
   argument : options object, with required 'filePath' and 'data' parameters.
 * @example
 *
    var data = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      options =
      {
        filePath : 'tmp/sample.txt',
        data : data,
        sync : false,
      };
    var con = wTools.fileWrite( options );
    con.got( function()
    {
        console.log('write finished');
    });
 * @param {Object} options write options
 * @param {string} options.filePath path to file is written.
 * @param {string|Buffer} [options.data=''] data to write
 * @param {boolean} [options.append=false] if this options sets to true, method appends passed data to existing data
    in a file
 * @param {boolean} [options.sync=true] if this parameter sets to false, method writes file asynchronously.
 * @param {boolean} [options.force=true] if it's set to false, method throws exception if parents dir in `filePath`
    path is not exists
 * @param {boolean} [options.silentError=false] if it's set to true, method will catch error, that occurs during
    file writes.
 * @param {boolean} [options.verbosity=false] if sets to true, method logs write process.
 * @param {boolean} [options.clean=false] if sets to true, method removes file if exists before writing
 * @returns {wConsequence}
 * @throws {Error} If arguments are missed
 * @throws {Error} If passed more then 2 arguments.
 * @throws {Error} If `filePath` argument or options.PathFile is not string.
 * @throws {Error} If `data` argument or options.data is not string or Buffer,
 * @throws {Error} If options has unexpected property.
 * @method fileWriteAct
 * @memberof wTools
 */

function fileWrite( o )
{
  var self = this;

  if( arguments.length === 2 )
  {
    o = { filePath : arguments[ 0 ], data : arguments[ 1 ] };
  }
  else
  {
    o = arguments[ 0 ];
    _.assert( arguments.length === 1 );
  }

  _.routineOptions( fileWrite,o );
  self._providerOptions( o );
  _.assert( _.strIs( o.filePath ),'expects string (-o.filePath-)' );

  var optionsWrite = _.mapScreen( self.fileWriteAct.defaults,o );
  optionsWrite.filePath = self.pathNativize( optionsWrite.filePath );

  /* log */

  function log()
  {
    if( o.verbosity )
    self.logger.log( '+ writing',_.toStr( o.data,{ levels : 0 } ),'to',optionsWrite.filePath );
  }

  log();

  /* makingDirectory */

  if( o.makingDirectory )
  {
    self.directoryMakeForFile( optionsWrite.filePath );
  }

  /* purging */

  if( o.purging )
  {
    self.fileDelete( optionsWrite.filePath );
  }

  var result = self.fileWriteAct( optionsWrite );

  if( !o.sync )
  {
    self.done.choke();
    result.doThen( self.done );
    // self.logger.log( 'self.done',self.done );
    // self.logger.log( 'self.nickName',self.nickName );
  }

  return result;
}

fileWrite.defaults =
{
  verbosity : null,
  makingDirectory : 1,
  purging : 0,
}

fileWrite.defaults.__proto__ = fileWriteAct.defaults;

fileWrite.having =
{
  bare : 0
}

fileWrite.having.__proto__ = fileWriteAct.having;


//

function fileWriteStream( o )
{
  var self = this;

  if( _.strIs( o ) )
  o = { filePath : o };

  _.assert( arguments.length === 1 );
  _.assert( _.strIs( o.filePath ) );

  _.routineOptions( fileWriteStream,o );

  var optionsWrite = _.mapExtend( Object.create( null ), o );
  optionsWrite.filePath = self.pathNativize( optionsWrite.filePath );

  return self.fileWriteStreamAct( optionsWrite );
}

fileWriteStream.defaults = {};

fileWriteStream.defaults.__proto__ = fileWriteStreamAct.defaults;

fileWriteStream.having =
{
  bare : 0
}

fileWriteStream.having.__proto__ = fileWriteStreamAct.having;

//

function fileAppend( o )
{
  var self = this;

  if( arguments.length === 2 )
  {
    o = { filePath : arguments[ 0 ], data : arguments[ 1 ] };
  }
  else
  {
    o = arguments[ 0 ];
    _.assert( arguments.length === 1 );
  }

  _.routineOptions( fileAppend,o );

  var optionsWrite = _.mapScreen( self.fileWriteAct.defaults,o );
  optionsWrite.filePath = self.pathNativize( optionsWrite.filePath );

  return self.fileWriteAct( optionsWrite );
}

fileAppend.defaults =
{
  writeMode : 'append',
}

fileAppend.defaults.__proto__ = fileWriteAct.defaults;

fileAppend.having =
{
  bare : 0
}

fileAppend.having.__proto__ = fileWriteAct.having;

//

/**
 * Writes data as json string to a file. `data` can be a any primitive type, object, array, array like. Method can
    accept options similar to fileWrite method, and have similar behavior.
 * Returns wConsequence instance.
 * By default method writes data synchronously, with replacing file if exists, and if parent dir hierarchy doesn't
 exist, it's created. Method can accept two parameters : string `filePath` and string\buffer `data`, or single
 argument : options object, with required 'filePath' and 'data' parameters.
 * @example
 * var fileProvider = _.FileProvider.Default();
 * var fs = require('fs');
   var data = { a : 'hello', b : 'world' },
   var con = fileProvider.fileWriteJson( 'tmp/sample.json', data );
   // file content : { "a" : "hello", "b" : "world" }

 * @param {Object} o write options
 * @param {string} o.filePath path to file is written.
 * @param {string|Buffer} [o.data=''] data to write
 * @param {boolean} [o.append=false] if this options sets to true, method appends passed data to existing data
 in a file
 * @param {boolean} [o.sync=true] if this parameter sets to false, method writes file asynchronously.
 * @param {boolean} [o.force=true] if it's set to false, method throws exception if parents dir in `filePath`
 path is not exists
 * @param {boolean} [o.silentError=false] if it's set to true, method will catch error, that occurs during
 file writes.
 * @param {boolean} [o.verbosity=false] if sets to true, method logs write process.
 * @param {boolean} [o.clean=false] if sets to true, method removes file if exists before writing
 * @param {string} [o.pretty=''] determines data stringify method.
 * @returns {wConsequence}
 * @throws {Error} If arguments are missed
 * @throws {Error} If passed more then 2 arguments.
 * @throws {Error} If `filePath` argument or options.PathFile is not string.
 * @throws {Error} If options has unexpected property.
 * @method fileWriteJson
 * @memberof wTools
 */

function fileWriteJson( o )
{
  var self = this;

  if( arguments.length === 2 )
  {
    o = { filePath : arguments[ 0 ], data : arguments[ 1 ] };
  }
  else
  {
    o = arguments[ 0 ];
    _.assert( arguments.length === 1 );
  }

  _.routineOptions( fileWriteJson,o );


  /* stringify */

  var originalData = o.data;
  if( o.jstructLike )
  {
    o.data = _.toJstruct( o.data );
  }
  else
  {
    if( o.pretty )
    o.data = _.toJson( o.data );
    else
    o.data = JSON.stringify( o.data );
  }

  if( o.prefix )
  o.data = o.prefix + o.data;

  /* validate */

  if( Config.debug && o.pretty ) try
  {

    // var parsedData = o.jstructLike ? _.exec( o.data ) : JSON.parse( o.data );
    // _.assert( _.entityEquivalent( parsedData,originalData ),'not identical' );

  }
  catch( err )
  {

    // debugger;
    self.logger.log( '-' );
    self.logger.error( 'JSON:' );
    self.logger.error( _.toStr( o.data,{ levels : 999 } ) );
    self.logger.log( '-' );
    throw _.err( 'Cant convert JSON\n',err );
    self.logger.log( '-' );

  }

  /* write */

  delete o.prefix;
  delete o.pretty;
  delete o.jstructLike;
  return self.fileWrite( o );
}

fileWriteJson.defaults =
{
  prefix : '',
  jstructLike : 0,
  pretty : 1,
  sync : null,
}

fileWriteJson.defaults.__proto__ = fileWrite.defaults;

var having = fileWriteJson.having = Object.create( null );

having.writing = 1;
having.reading = 0;
having.bare = 0;

//

function fileWriteJstruct( o )
{
  var self = this;

  if( arguments.length === 2 )
  {
    o = { filePath : arguments[ 0 ], data : arguments[ 1 ] };
  }
  else
  {
    o = arguments[ 0 ];
    _.assert( arguments.length === 1 );
  }

  _.routineOptions( fileWriteJstruct,o );

  return self.fileWriteJson( o );
}

fileWriteJstruct.defaults =
{
  jstructLike : 1,
}

fileWriteJstruct.defaults.__proto__ = fileWriteJson.defaults;

var having = fileWriteJstruct.having = Object.create( null );

having.writing = 1;
having.reading = 0;
having.bare = 0;

//

function fileTouch( o )
{
  var self = this;

  if( _.strIs( o ) )
  o = { filePath : o };

  o.filePath = _.pathGet( o.filePath );

  _.assert( _.strIs( o.filePath ), 'expects path ( o.filePath )' );
  _.assert( o.data === undefined );
  _.assert( arguments.length === 1 );

  var stat = self.fileStat( o.filePath );
  if( stat )
  {
    if( !self.fileIsTerminal( o.filePath ) )
    {
      throw _.err( o.filePath,'is not terminal' );
      return null;
    }
  }

  o.data = stat ? self.fileRead( o.filePath ) : '';
  self.fileWrite( o );

  return self;
}

var having = fileTouch.having = Object.create( null );

having.writing = 1;
having.reading = 0;
having.bare = 0;

//

// function filesWrite( o )
// {
//   var self = this;
//
//   if( _.strIs( o.filePath ) || o.filePath instanceof _.FileRecord )
//   o.filePath = [ o.filePath ];
//
//   _.routineOptions( filesWrite,o );
//   _.assert( o.sync,'async is not implemented' );
//   _.assert( _.arrayIs( o.filePath ) || _.objectIs( o.filePath ) );
//
//   var result = _.entityMap( o.filePath,function( e,k )
//   {
//
//     var filePath = _.pathGet( e );
//     var optionsForWrite = _.mapExtend( null,o );
//     optionsForWrite.filePath = filePath;
//
//     return self.fileWrite( optionsForWrite );
//   });
//
//   return result;
// }
//
// filesWrite.defaults =
// {
// }
//
// filesWrite.defaults.__proto__ = fileWrite.defaults;

//

function fileTimeSet( o )
{
  var self = this;

  if( arguments.length === 3 )
  o =
  {
    filePath : arguments[ 0 ],
    atime : arguments[ 1 ],
    mtime : arguments[ 2 ],
  }
  else
  {
    _.assert( arguments.length === 1 );
  }

  _.routineOptions( fileTimeSet,o );
  o.filePath = self.pathNativize( o.filePath );

  return self.fileTimeSetAct( o );
}

fileTimeSet.defaults = {};

fileTimeSet.defaults.__proto__ = fileTimeSetAct.defaults;

fileTimeSet.having =
{
  bare : 0
}

fileTimeSet.having.__proto__ = fileTimeSetAct.having;

//

function fileDelete()
{
  var self = this;

  // optionsWrite.filePath = self.pathNativize( optionsWrite.filePath );

  throw _.err( 'not implemented' );

}

fileDelete.defaults =
{
  force : 1,
}

fileDelete.defaults.__proto__ = fileDeleteAct.defaults;

fileDelete.having =
{
  bare : 0
}

fileDelete.having.__proto__ = fileDeleteAct.having;

//

function fileDeleteForce( o )
{
  var self = this;

  if( _.strIs( o ) )
  o = { filePath : o };

  var o = _.routineOptions( fileDeleteForce,o );
  _.assert( arguments.length === 1 );

  return self.fileDelete( o );
}

fileDeleteForce.defaults =
{
  force : 1,
  sync : null,
}

fileDeleteForce.defaults.__proto__ = fileDelete.defaults;

var having = fileDeleteForce.having = Object.create( null );

having.writing = 1;
having.reading = 0;
having.bare = 0;

//

function directoryMake( o )
{
  var self = this;

  _.assert( arguments.length === 1 );

  if( _.strIs( o ) )
  o = { filePath : o };

  _.routineOptions( directoryMake,o );
  self._providerOptions( o );

  // debugger;
  if( o.force )
  throw _.err( 'not implemented' );
  // !!! need this, probably

  if( o.rewritingTerminal )
  if( self.fileIsTerminal( o.filePath ) )
  self.fileDelete( o.filePath );

  if( _.strIs( o.filePath ) )
  o.filePath = self.pathNativize( o.filePath );

  return self.directoryMakeAct( o );
}

directoryMake.defaults =
{
  force : 1,
  rewritingTerminal : 1,
}

directoryMake.defaults.__proto__ = directoryMakeAct.defaults;

directoryMake.having =
{
  bare : 0
}

directoryMake.having.__proto__ = directoryMakeAct.having;

//

function directoryMakeForFile( o )
{
  var self = this;

  if( _.strIs( o ) )
  o = { filePath : o };

  _.routineOptions( directoryMakeForFile,o );
  _.assert( arguments.length === 1 );

  o.filePath = _.pathDir( o.filePath );

  return self.directoryMake( o );
}

directoryMakeForFile.defaults =
{
  force : 1,
}

directoryMakeForFile.defaults.__proto__ = directoryMake.defaults;

var having = directoryMakeForFile.having = Object.create( null );

having.writing = 1;
having.reading = 0;
having.bare = 0;

//

function _linkBegin( routine,args )
{
  var self = this;
  var o;

  if( args.length === 2 )
  {
    o =
    {
      dstPath : args[ 0 ],
      srcPath : args[ 1 ],
    }
    _.assert( args.length === 2 );
  }
  else
  {
    o = args[ 0 ];
    _.assert( args.length === 1 );
  }

  _.routineOptions( routine,o );
  self._providerOptions( o );

  if( o.filePathes )
  return o;

  o.dstPath = _.pathGet( o.dstPath );
  o.srcPath = _.pathGet( o.srcPath );

  // if( o.verbosity )
  // self.logger.log( routine.name,':', o.dstPath + ' <- ' + o.srcPath );

  return o;
}

//

function _linkMultiple( o,link )
{
  var self = this;

  if( o.filePathes.length < 2 )
  return o.sync ? true : new wConsequence().give( true );

  _.assert( o );
  // _.assert( o.sync,'not implemented' );

  var needed = 0;
  var records = self.fileRecords( o.filePathes );

  var newestRecord = _.entityMax( records,( record ) => record.stat ? record.stat.mtime.getTime() : 0 ).element;
  for( var p = 0 ; p < records.length ; p++ )
  {
    var record = records[ p ];
    if( !record.stat || !_.statsAreLinked( newestRecord.stat,record.stat ) )
    {
      needed = 1;
      break;
    }
  }

  if( !needed )
  return o.sync ? true : new wConsequence().give( true );

  var mostLinkedRecord = _.entityMax( records,( record ) => record.stat ? record.stat.nlink : 0 ).element;
  if( mostLinkedRecord.absolute !== newestRecord.absolute )
  {
    var read = self.fileRead( newestRecord.absolute );
    self.fileWrite( mostLinkedRecord.absolute,read );
  }

  /* */

  function onRecord( record )
  {
    // var record = records[ p ];
    if( record === mostLinkedRecord )
    return o.sync ? true : new wConsequence().give( true );

    if( !o.allowDiffContent )
    if( record.stat && newestRecord.stat.mtime.getTime() === record.stat.mtime.getTime() )
    {
      // debugger;
      // throw _.err( 'not tested' )
      if( !_.statsCouldHaveSameContent( newestRecord.stat , record.stat ) )
      {
        var err = _.err( 'several files has same date bu different content',newestRecord.absolute,record.absolute );
        if( o.sync )
        throw err;
        else
        return new wConsequence().error( err );
      }
    }
    if( !record.stat || !_.statsAreLinked( mostLinkedRecord.stat , record.stat ) )
    {
      // debugger;
      // throw _.err( 'not tested' )
      var linkOptions = _.mapExtend( null,o );
      delete linkOptions.filePathes;
      linkOptions.dstPath = record.absolute;
      linkOptions.srcPath = mostLinkedRecord.absolute;
      return link.call( self,linkOptions );
    }

    return o.sync ? true : new wConsequence().give( true );
  }

  //

  if( o.sync )
  {
    for( var p = 0 ; p < records.length ; p++ )
    {
      if( !onRecord( records[ p ] ) )
      return false;
    }

    return true;
  }
  else
  {
    var throwing = o.throwing;
    o.throwing = 1;
    var cons = [];

    var result = { err : undefined, got : true };

    function handler( err, got )
    {
      if( err && !_.definedIs( result.err ) )
      result.err = err;
      else
      result.got &= got;
    }

    for( var p = 0 ; p < records.length ; p++ )
    cons.push( onRecord( records[ p ] ).tap( handler ) );

    var con = new wConsequence().give();

    con.andThen( cons )
    .doThen( () =>
    {
      // console.log( _.errIs( result.err ) )
      if( result.err )
      {
        if( throwing )
        throw result.err;
        else
        return false;
      }
      return result.got;
    });

    return con;
  }

  // debugger;
  // return true;
}

//

function _link_functor( gen )
{

  _.assert( arguments.length === 1 );
  _.routineOptions( _link_functor,gen );

  var nameOfMethod = gen.nameOfMethod;
  var nameOfMethodPure = _.strRemoveEnd( gen.nameOfMethod,'Act' );

  /* */

  function link( o )
  {

    var self = this;
    var linkAct = self[ nameOfMethod ];
    var o = self._linkBegin( link,arguments );

    if( o.filePathes )
    return _linkMultiple.call( self,o,link );

    var optionsAct = _.mapScreen( linkAct.defaults,o );
    optionsAct.dstPath = self.pathNativize( optionsAct.dstPath );
    optionsAct.srcPath = self.pathNativize( optionsAct.srcPath );

    if( optionsAct.dstPath === optionsAct.srcPath )
    {
      if( o.sync )
      return true;
      return new wConsequence().give( true );
    }

    if( !self.fileStat( o.srcPath ) )
    {

      if( o.throwing )
      {
        var err = _.err( 'src file does not exist',o.srcPath );
        if( o.sync )
        throw err;
        return new wConsequence().error( err );
      }
      else
      {
        if( o.sync )
        return false;
        return new wConsequence().give( false );
      }

    }

    /* !!! this is odd. what is it for? */
    // if( nameOfMethod === 'fileCopyAct' )
    // if( !self.fileIsTerminal( o.srcPath ) )
    // {
    //   var err = _.err( o.srcPath,' is not a terminal file!' );
    //   if( o.sync )
    //   throw err;
    //   return new wConsequence().error( err );
    // }

    /* */

    function log()
    {
      if( !o.verbosity )
      return;
      var c = _.pathCommon([ o.dstPath,o.srcPath ]);
      if( c.length > 1 )
      self.logger.log( '+',nameOfMethodPure,':',c,':',_.pathRelative( c,o.dstPath ),'<-',_.pathRelative( c,o.srcPath ) );
      else
      self.logger.log( '+',nameOfMethodPure,':',o.dstPath,'<-',o.srcPath );
    }

    /* */

    function tempNameMake()
    {
      return optionsAct.dstPath + '-' + _.idWithGuid() + '.tmp';
    }

    /* */

    if( o.sync )
    {

      var temp;
      try
      {
        // debugger;
        if( self.fileStatAct({ filePath : optionsAct.dstPath }) )
        {
          if( !o.rewriting )
          throw _.err( 'dst file exist and rewriting is forbidden :',o.dstPath );
          temp = tempNameMake();
          if( self.fileStatAct({ filePath : temp }) )
          {
            temp = null;
            self.fileDelete( o.dstPath );
          }
          if( temp )
          self.fileRenameAct({ dstPath : temp, srcPath : optionsAct.dstPath, sync : 1 });
        }
        linkAct.call( self,optionsAct );
        log();
        if( temp )
        self.fileDelete( temp );

      }
      catch( err )
      {

        if( temp ) try
        {
          self.fileRenameAct({ dstPath : optionsAct.dstPath, srcPath : temp, sync : 1 });
        }
        catch( err2 )
        {
        }

        if( o.throwing )
        throw _.err( 'cant',nameOfMethod,o.dstPath,'<-',o.srcPath,'\n',err )
        return false;

      }

      return true;
    }
    else
    {

      // debugger;
      // throw _.err( 'not tested' );

      var temp = '';
      var dstExists,tempExists;

      return self.fileStatAct({ filePath : optionsAct.dstPath, sync : 0 })
      .ifNoErrorThen( function( exists )
      {

        dstExists = exists;
        if( dstExists )
        {
          if( !o.rewriting )
          {
            var err = _.err( 'dst file exist and rewriting is forbidden :',optionsAct.dstPath );
            if( o.throwing )
            throw err;
            else
            throw _.errAttend( err );
          }

          // throw _.err( 'not tested' );
          return self.fileStatAct({ filePath : temp, sync : 0 });
        }

      })
      .ifNoErrorThen( function( exists )
      {

        if( !dstExists )
        return;

        tempExists = exists;
        if( !tempExists )
        {
          temp = tempNameMake();
          return self.fileRenameAct({ dstPath : temp, srcPath : optionsAct.dstPath, sync : 0 });
        }
        else
        {
          return self.fileDelete({ filePath : optionsAct.dstPath , sync : 0 });
        }

      })
      .ifNoErrorThen( function()
      {

        log();

        return linkAct.call( self,optionsAct );

      })
      .ifNoErrorThen( function()
      {

        if( temp )
        return self.fileDelete({ filePath : temp, sync : 0 });

      })
      .doThen( function( err )
      {

        if( err )
        {
          var con = new wConsequence().give();
          if( temp )
          {
            con.doThen( _.routineSeal( self,self.fileRenameAct,
            [{
              dstPath : optionsAct.dstPath,
              srcPath : temp,
              sync : 0,
              // verbosity : 0,
            }]));
          }

          return con.doThen( function()
          {
            if( o.throwing )
            throw _.errLogOnce( err );
            return false;
          });
        }

        return true;
      })
      ;

    }

  }

  return link;
}

_link_functor.defaults =
{
  nameOfMethod : null,
}

//

var fileRename = _link_functor({ nameOfMethod : 'fileRenameAct' });

fileRename.defaults =
{
  rewriting : 0,
  throwing : null,
  verbosity : null,
}

fileRename.defaults.__proto__ = fileRenameAct.defaults;

fileRename.having =
{
  bare : 0
}

fileRename.having.__proto__ = fileRenameAct.having;

//

/**
 * Creates copy of a file. Accepts two arguments: ( srcPath ),( dstPath ) or options object.
 * Returns true if operation is finished successfully or if source and destination pathes are equal.
 * Otherwise throws error with corresponding message or returns false, it depends on ( o.throwing ) property.
 * In asynchronously mode returns wConsequence instance.
 * @example
   var fileProvider = _.FileProvider.Default();
   var result = fileProvider.fileCopy( 'src.txt','dst.txt' );
   console.log( result );// true
   var stats = fileProvider.fileStat( 'dst.txt' );
   console.log( stats ); // returns Stats object
 * @example
   var fileProvider = _.FileProvider.Default();
   var consequence = fileProvider.fileCopy
   ({
     srcPath : 'src.txt',
     dstPath : 'dst.txt',
     sync : 0
   });
   consequence.got( function( err, got )
   {
     if( err )
     throw err;
     console.log( got ); // true
     var stats = fileProvider.fileStat( 'dst.txt' );
     console.log( stats ); // returns Stats object
   });

 * @param {Object} o - options object.
 * @param {string} o.srcPath path to source file.
 * @param {string} o.dstPath path where to copy source file.
 * @param {boolean} [o.sync=true] If set to false, method will copy file asynchronously.
 * @param {boolean} [o.rewriting=true] Enables rewriting of destination path if it exists.
 * @param {boolean} [o.throwing=true] Enables error throwing.
 * @param {boolean} [o.verbosity=true] Enables logging of copy process.
 * @returns {wConsequence}
 * @throws {Error} If missed argument, or pass more than 2.
 * @throws {Error} If dstPath or dstPath is not string.
 * @throws {Error} If options object has unexpected property.
 * @throws {Error} If ( o.rewriting ) is false and destination path exists.
 * @throws {Error} If path to source file( srcPath ) not exists and ( o.throwing ) is enabled, otherwise returns false.
 * @method fileCopy
 * @memberof wTools
 */

var fileCopy = _link_functor({ nameOfMethod : 'fileCopyAct' });

fileCopy.defaults =
{
  rewriting : 1,
  throwing : null,
  verbosity : null,
}

fileCopy.defaults.__proto__ = fileCopyAct.defaults;

fileCopy.having =
{
  bare : 0
}

fileCopy.having.__proto__ = fileCopyAct.having;

//

/**
 * link methods options
 * @typedef { object } wTools~linkOptions
 * @property { boolean } [ dstPath= ] - Target file.
 * @property { boolean } [ srcPath= ] - Source file.
 * @property { boolean } [ o.sync=true ] - Runs method in synchronously. Otherwise asynchronously and returns wConsequence object.
 * @property { boolean } [ rewriting=true ] - Rewrites target( o.dstPath ).
 * @property { boolean } [ verbosity=true ] - Logs working process.
 * @property { boolean } [ throwing=true ]- Enables error throwing. Otherwise returns true/false.
 */

/**
 * Creates soft link( symbolic ) to existing source( o.srcPath ) named as ( o.dstPath ).
 * Rewrites target( o.dstPath ) by default if it exist. Logging of working process is controled by option( o.verbosity ).
 * Returns true if link is successfully created. If some error occurs during execution method uses option( o.throwing ) to
 * determine what to do - throw error or return false.
 *
 * @param { wTools~linkOptions } o - options { @link wTools~linkOptions  }
 *
 * @method linkSoft
 * @throws { exception } If( o.srcPath ) doesn`t exist.
 * @throws { exception } If cant link ( o.srcPath ) with ( o.dstPath ).
 * @memberof wTools
 */

var linkSoft = _link_functor({ nameOfMethod : 'linkSoftAct' });

linkSoft.defaults =
{
  rewriting : 1,
  verbosity : null,
  throwing : null,
}

linkSoft.defaults.__proto__ = linkSoftAct.defaults;

linkSoft.having =
{
  bare : 0
}

linkSoft.having.__proto__ = linkSoftAct.having;

//

/**
 * Creates hard link( new name ) to existing source( o.srcPath ) named as ( o.dstPath ).
 * Rewrites target( o.dstPath ) by default if it exist. Logging of working process is controled by option( o.verbosity ).
 * Returns true if link is successfully created. If some error occurs during execution method uses option( o.throwing ) to
 * determine what to do - throw error or return false.
 *
 * @param { wTools~linkOptions } o - options { @link wTools~linkOptions  }
 *
 * @method linkSoft
 * @throws { exception } If( o.srcPath ) doesn`t exist.
 * @throws { exception } If cant link ( o.srcPath ) with ( o.dstPath ).
 * @memberof wTools
 */

var linkHard = _link_functor({ nameOfMethod : 'linkHardAct' });

linkHard.defaults =
{
  filePathes : null,
  rewriting : 1,
  verbosity : null,
  throwing : null,
  allowDiffContent : 0
}

linkHard.defaults.__proto__ = linkHardAct.defaults;

linkSoft.having =
{
  bare : 0
}

linkSoft.having.__proto__ = linkSoftAct.having;

// debugger;
// console.log( 'linkHard.defaults',linkHard.defaults );
// debugger;

//

function fileExchange( o )
{
  var self  = this;

  _.assert( arguments.length === 1 || arguments.length === 2 )

  if( arguments.length === 2 )
  {
    _.assert( _.strIs( arguments[ 0 ] ) && _.strIs( arguments[ 1 ] ) );
    o = { dstPath : arguments[ 0 ], srcPath : arguments[ 1 ] };
  }

  _.routineOptions( fileExchange,o );
  self._providerOptions( o );

  var dstPath = o.dstPath;
  var srcPath = o.srcPath;

  var allowMissing = o.allowMissing;
  delete o.allowMissing;

  var src = self.fileStat({ filePath : o.srcPath, throwing : 0 });
  var dst = self.fileStat({ filePath : o.dstPath, throwing : 0 });

  function _returnNull()
  {
    if( o.sync )
    return null;
    else
    return new wConsequence().give( null );
  }

  if( !src || !dst )
  {
    if( allowMissing )
    {
      if( !src && dst )
      {
        o.srcPath = o.dstPath;
        o.dstPath = srcPath;
      }
      if( !src && !dst )
      return _returnNull();

      return self.fileRename( o );
    }
    else if( o.throwing )
    {
      var err;

      if( !src && !dst )
      {
        err = _.err( 'srcPath and dstPath not exist! srcPath: ', o.srcPath, ' dstPath: ', o.dstPath )
      }
      else if( !src )
      {
        err = _.err( 'srcPath not exist! srcPath: ', o.srcPath );
      }
      else
      {
        err = _.err( 'dstPath not exist! dstPath: ', o.dstPath );
      }

      if( o.sync )
      throw err;
      else
      return new wConsequence().error( err );
    }
    else
    return _returnNull();
  }

  var temp = o.srcPath + '-' + _.idWithGuid() + '.tmp';

  o.dstPath = temp;

  if( o.sync )
  {
    self.fileRename( o );
    o.dstPath = o.srcPath;
    o.srcPath = dstPath;
    self.fileRename( o );
    o.dstPath = dstPath;
    o.srcPath = temp;
    return self.fileRename( o );
  }
  else
  {
    var con = new wConsequence().give();

    con.ifNoErrorThen( _.routineSeal( self, self.fileRename, [ o ] ) )
    .ifNoErrorThen( function()
    {
      o.dstPath = o.srcPath;
      o.srcPath = dstPath;
    })
    .ifNoErrorThen( _.routineSeal( self, self.fileRename, [ o ] ) )
    .ifNoErrorThen( function()
    {
      o.dstPath = dstPath;
      o.srcPath = temp;
    })
    .ifNoErrorThen( _.routineSeal( self, self.fileRename, [ o ] ) );

    return con;
  }
}

fileExchange.defaults =
{
  srcPath : null,
  dstPath : null,
  sync : null,
  allowMissing : 1,
  throwing : null,
  verbosity : null
}

var having = fileExchange.having = Object.create( null );

having.writing = 1;
having.reading = 0;
having.bare = 0;

// --
// encoders
// --

var encoders = {};

encoders[ 'buffer' ] =
{

  onBegin : function( e )
  {
    _.assert( 0,'"buffer" is forbidden encoding, please use "buffer-node" or "buffer-raw"' );
  },

}

encoders[ 'arraybuffer' ] =
{

  onBegin : function( e )
  {
    _.assert( 0,'"arraybuffer" is forbidden encoding, please use "buffer-raw"' );
  },

}

encoders[ 'json' ] =
{

  onBegin : function( e )
  {
    _.assert( e.transaction.encoding === 'json' );
    e.transaction.encoding = 'utf8';
  },

  onEnd : function( e )
  {
    if( !_.strIs( e.data ) )
    throw _.err( '( fileRead.encoders.json.onEnd ) expects string' );
    var result = JSON.parse( e.data );
    return result;
  },

}

encoders[ 'jstruct' ] =
{

  onBegin : function( e )
  {
    e.transaction.encoding = 'utf8';
  },

  onEnd : function( e )
  {
    if( !_.strIs( e.data ) )
    throw _.err( '( fileRead.encoders.jstruct.onEnd ) expects string' );
    var result = _.exec({ code : e.data, filePath : e.transaction.filePath });
    return result;
  },

}

encoders[ 'js' ] = encoders[ 'jstruct' ];

fileRead.encoders = encoders;

// --
// relationship
// --

var WriteMode = [ 'rewrite','prepend','append' ];

var providerDefaults =
[
  'resolvingSoftLink',
  'resolvingTextLink',
  'sync',
  'throwing',
  'verbosity'
]

var Composes =
{
  done : new wConsequence().give(),
  resolvingSoftLink : 1,
  resolvingTextLink : 0,
  sync : 1,
  throwing : 1,
  verbosity : 0
}

var Aggregates =
{
}

var Associates =
{
  logger : logger,
}

var Restricts =
{
}

var Statics =
{
  verbosity : 0,
  WriteMode : WriteMode,
  providerDefaults : providerDefaults
}

// --
// prototype
// --

var Proto =
{

  init : init,

  // path

  localFromUrl : localFromUrl,
  urlFromLocal : urlFromLocal,

  // etc

  _fileOptionsGet : _fileOptionsGet,
  _providerOptions : _providerOptions,
  fileRecord : fileRecord,
  fileRecords : fileRecords,
  fileRecordsFiltered : fileRecordsFiltered,
  pathNativize : pathNativize,
  pathsNativize : pathsNativize,


  // read act

  fileReadAct : fileReadAct,
  fileReadStreamAct : fileReadStreamAct,
  fileStatAct : fileStatAct,
  fileHashAct : fileHashAct,

  directoryReadAct : directoryReadAct,


  // read content

  fileRead : fileRead,
  fileReadStream : fileReadStream,
  fileReadSync : fileReadSync,
  fileReadJson : fileReadJson,

  fileHash : fileHash,
  filesFingerprints : filesFingerprints,

  filesSame : filesSame,
  filesLinked : filesLinked,

  directoryRead : directoryRead,


  // read stat

  fileStat : fileStat,
  fileIsTerminal : fileIsTerminal,
  fileIsSoftLink : fileIsSoftLink,

  filesSize : filesSize,
  fileSize : fileSize,

  directoryIs : directoryIs,
  directoryIsEmpty : directoryIsEmpty,


  // write act

  fileWriteAct : fileWriteAct,
  fileWriteStreamAct : fileWriteStreamAct,
  fileTimeSetAct : fileTimeSetAct,
  fileDeleteAct : fileDeleteAct,

  directoryMakeAct : directoryMakeAct,

  fileRenameAct : fileRenameAct,
  fileCopyAct : fileCopyAct,
  linkSoftAct : linkSoftAct,
  linkHardAct : linkHardAct,


  // write

  fileTouch : fileTouch,
  fileWrite : fileWrite,
  fileWriteStream : fileWriteStream,
  fileAppend : fileAppend,
  fileWriteJson : fileWriteJson,
  fileWriteJstruct : fileWriteJstruct,

  fileTimeSet : fileTimeSet,

  fileDelete : fileDelete,
  fileDeleteForce : fileDeleteForce,

  directoryMake : directoryMake,
  directoryMakeForFile : directoryMakeForFile,

  _linkBegin : _linkBegin,
  _linkMultiple : _linkMultiple,
  _link_functor : _link_functor,

  fileRename : fileRename,
  fileCopy : fileCopy,
  linkSoft : linkSoft,
  linkHard : linkHard,

  fileExchange : fileExchange,


  // relationships

  constructor : Self,
  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,
  Restricts : Restricts,
  Statics : Statics,

}

//

_.classMake
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

wCopyable.mixin( Self );

//

_.FileProvider[ Self.nameShort ] = Self;
if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();
