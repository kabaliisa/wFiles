( function _RecordFilter_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  let _ = require( '../../Tools.s' );

  if( !_global_.wTools.FileProvider )
  require( '../files/UseTop.s' );

  _.include( 'wTesting' );

}

//

var _ = _global_.wTools;
var Parent = wTester;
var testSuitePath;

// --
// context
// --

function onSuiteBegin()
{
  if( Config.platform === 'nodejs' )
  testSuitePath = _.path.dirTempOpen( _.path.join( __dirname, '../..' ), 'FileRecordFilter' );
  else
  testSuitePath = _.path.current();
}

//

function onSuiteEnd()
{
  if( Config.platform === 'nodejs' )
  {
    _.assert( _.strHas( testSuitePath, 'FileRecordFilter' ) );
    _.path.dirTempClose( testSuitePath );
  }
}

// --
// tests
// --

function make( test )
{
  let provider = new _.FileProvider.Extract();

  /* */

  test.case = 'filter from options map';
  var filter = provider.recordFilter({ filePath : '/src' });
  logger.log( filter );
  test.identical( filter.filePath, '/src' );
  test.identical( filter.prefixPath, null );
  test.identical( filter.postfixPath, null );
  test.identical( filter.basePath, null );
  test.identical( filter.formed, 1 );

  filter.form();
  logger.log( filter );
  test.identical( filter.filePath, { '/src' : '' } );
  test.identical( filter.prefixPath, null );
  test.identical( filter.postfixPath, null );
  test.identical( filter.basePath, { '/src' : '/src' } );
  test.identical( filter.formed, 5 );

  /* */

  test.case = 'filter copy string';
  var filter = provider.recordFilter( '/src' );
  test.identical( filter.filePath, '.' );
  test.identical( filter.prefixPath, '/src' );
  test.identical( filter.postfixPath, null );
  test.identical( filter.basePath, null );
  test.identical( filter.formed, 1 );

  filter.copy( '/dst' );
  test.identical( filter.filePath, '.' );
  test.identical( filter.prefixPath, '/dst' );
  test.identical( filter.postfixPath, null );
  test.identical( filter.basePath, null );
  test.identical( filter.formed, 1 );

  /* */

  test.case = 'filter copy array';
  var filter = provider.recordFilter([ '/src1', '/src2' ]);
  test.identical( filter.filePath, '.' );
  test.identical( filter.prefixPath, [ '/src1', '/src2' ] );
  test.identical( filter.postfixPath, null );
  test.identical( filter.basePath, null );
  test.identical( filter.formed, 1 );

  filter.copy( [ '/dst1', '/dst2' ] );
  test.identical( filter.filePath, '.' );
  test.identical( filter.prefixPath, [ '/dst1', '/dst2' ] );
  test.identical( filter.postfixPath, null );
  test.identical( filter.basePath, null );
  test.identical( filter.formed, 1 );

  /* */

  test.case = 'filter from string';
  var filter = provider.recordFilter( '/src' );
  logger.log( filter );
  test.identical( filter.filePath, '.' );
  test.identical( filter.prefixPath, '/src' );
  test.identical( filter.postfixPath, null );
  test.identical( filter.basePath, null );
  test.identical( filter.formed, 1 );

  filter.form();
  logger.log( filter );
  test.identical( filter.filePath, { '/src' : '' } );
  test.identical( filter.prefixPath, null );
  test.identical( filter.postfixPath, null );
  test.identical( filter.basePath, { '/src' : '/src' } );
  test.identical( filter.formed, 5 );

  /* */

  test.case = 'filter from array';
  var filter = provider.recordFilter([ '/src/a', '/src/b' ]);
  logger.log( filter );
  test.identical( filter.filePath, '.' );
  test.identical( filter.prefixPath, [ '/src/a', '/src/b' ] );
  test.identical( filter.postfixPath, null );
  test.identical( filter.basePath, null );
  test.identical( filter.formed, 1 );

  filter.form();
  logger.log( filter );
  test.identical( filter.filePath, { '/src/a' : '', '/src/b' : '' } );
  test.identical( filter.prefixPath, null );
  test.identical( filter.postfixPath, null );
  test.identical( filter.basePath, { '/src/a' : '/src/a', '/src/b' : '/src/b' } );
  test.identical( filter.formed, 5 );

  /* */

  test.case = 'filter from array, have relative path';
  var filter = provider.recordFilter([ '/src/a', 'src/b' ]);
  logger.log( filter );
  test.identical( filter.filePath, '.' );
  test.identical( filter.prefixPath, [ '/src/a', 'src/b' ] );
  test.identical( filter.postfixPath, null );
  test.identical( filter.basePath, null );
  test.identical( filter.formed, 1 );

  filter.form();
  logger.log( filter );
  test.identical( filter.filePath, { '/src/a' : '', '/src/a/src/b' : '' } );
  test.identical( filter.prefixPath, null );
  test.identical( filter.postfixPath, null );
  test.identical( filter.basePath, { '/src/a' : '/src/a', '/src/a/src/b' : '/src/a' } );
  test.identical( filter.formed, 5 );

  /* */

  /* */

  if( !Config.debug )
  return;

  /* */

  test.description = 'bad options';

  test.shouldThrowError( () => provider.recordFilter({ '/xx' : '/src' }) );
  test.shouldThrowError( () => provider.recordFilter( 1 ) );

}

//

function form( test )
{
  let provider = _.fileProvider;

  /* */

  test.case = 'base path is relative';
  var filter = provider.recordFilter();
  filter.filePath = [ '/a/b/*', '/a/c/*' ];
  filter.basePath = '..';
  filter.form();
  test.identical( filter.formed, 5 );
  test.identical( filter.formedFilePath, { '/a/b' : '', '/a/c' : '' } );
  test.identical( filter.formedBasePath, { '/a/b' : '/a', '/a/c' : '/a' } );
  test.identical( filter.filePath, { '/a/b/*' : '', '/a/c/*' : '' } );
  test.identical( filter.basePath, { '/a/b/*' : '/a', '/a/c/*' : '/a' } );
  test.identical( filter.prefixPath, null );
  test.identical( filter.postfixPath, null );

  /* */

  test.case = 'base path and file path are relative, without glob';
  var filter = provider.recordFilter();
  filter.prefixPath = '/src';
  filter.basePath = '.';
  filter.filePath = { 'd' : true };

  filter._formPaths();
  test.identical( filter.formed, 3 );
  test.identical( filter.formedFilePath, null );
  test.identical( filter.formedBasePath, null );
  test.identical( filter.filePath, { '/src/d' : true } );
  test.identical( filter.basePath, { '/src/d' : '/src' } );
  test.identical( filter.prefixPath, null );
  test.identical( filter.postfixPath, null );

  filter.form();
  test.identical( filter.formed, 5 );
  test.identical( filter.formedFilePath, { '/src/d' : '' } );
  test.identical( filter.formedBasePath, { '/src/d' : '/src' } );
  test.identical( filter.filePath, { '/src/d' : true } );
  test.identical( filter.basePath, { '/src/d' : '/src' } );
  test.identical( filter.prefixPath, null );
  test.identical( filter.postfixPath, null );

  /* */

  test.case = 'pair paired empty filters, form dst first';
  var src = provider.recordFilter();
  var dst = provider.recordFilter();
  src.pairWithDst( dst )
  src.pairRefineLight();

  dst.form();
  src.form();

  test.identical( src.hasAnyPath(), false );
  test.identical( src.filePath, {} );
  test.identical( src.prefixPath, null );
  test.identical( src.postfixPath, null );
  test.identical( src.basePath, {} );

  test.identical( dst.hasAnyPath(), false );
  test.identical( dst.filePath, {} );
  test.identical( dst.prefixPath, null );
  test.identical( dst.postfixPath, null );
  test.identical( dst.basePath, null );

  /* */

  test.case = 'pair paired empty filters, form src first';
  var src = provider.recordFilter();
  var dst = provider.recordFilter();
  src.pairWithDst( dst )
  src.pairRefineLight();

  src.form();
  dst.form();

  test.identical( src.hasAnyPath(), false );
  test.identical( src.filePath, {} );
  test.identical( src.prefixPath, null );
  test.identical( src.postfixPath, null );
  test.identical( src.basePath, {} );

  test.identical( dst.hasAnyPath(), false );
  test.identical( dst.filePath, {} );
  test.identical( dst.prefixPath, null );
  test.identical( dst.postfixPath, null );
  test.identical( dst.basePath, null );

  /* */

  test.case = 'drops redundant base path';

  var filter = provider.recordFilter({});
  filter.filePath = { '/dir/**b**' : '' };
  filter.prefixPath = [ '/dir/d1/**', '/dir/d2/**' ];
  filter.basePath = './d11';
  filter.form();

  test.identical( filter.formed, 5 );
  test.identical( filter.formedFilePath, { '/dir' : '' } );
  test.identical( filter.formedBasePath, { '/dir' : '/dir/d1/d11' } );
  test.identical( filter.filePath, { '/dir/**b**' : '' } );
  test.identical( filter.basePath, { '/dir/**b**' : '/dir/d1/d11' } );
  test.identical( filter.prefixPath, null );
  test.identical( filter.postfixPath, null );

  /* */

  test.case = 'entangled, base path and file path are relative, without glob, only bools';
  var filter = provider.recordFilter();
  filter.prefixPath = '/src';
  filter.basePath = '.';
  filter.filePath = { 'a/b' : true, 'a/c' : true };
  filter.form();
  test.identical( filter.formed, 5 );
  test.identical( filter.formedFilePath, { '/src/a/b' : '', '/src/a/c' : '' } );
  test.identical( filter.formedBasePath, { '/src/a/b' : '/src', '/src/a/c' : '/src' } );
  test.identical( filter.filePath, { '/src/a/b' : true, '/src/a/c' : true } );
  test.identical( filter.basePath, { '/src/a/b' : '/src', '/src/a/c' : '/src' } );
  test.identical( filter.prefixPath, null );
  test.identical( filter.postfixPath, null );

  test.case = 'entangled, base path and file path are relative, with glob, only bools';
  var filter = provider.recordFilter();
  filter.prefixPath = '/src/*';
  filter.basePath = '.';
  filter.filePath = { 'a/b' : true, 'a/c' : true };
  filter.form();
  test.identical( filter.prefixPath, null );
  test.identical( filter.postfixPath, null );
  test.identical( filter.filePath, { '/src/*/a/b' : true, '/src/*/a/c' : true } );
  test.identical( filter.basePath, { '/src/*/a/b' : '/src', '/src/*/a/c' : '/src' } );
  test.identical( filter.formedFilePath, { '/src' : '' } );
  test.identical( filter.formedBasePath, { '/src' : '/src' } );
  test.identical( filter.formed, 5 );

  test.case = 'entangled, base path and file path are relative, with glob, not only bools';
  var filter = provider.recordFilter();
  filter.prefixPath = '/src/*';
  filter.basePath = '.';
  filter.filePath = { 'a/b' : '', 'a/c' : true };
  filter.form();
  test.identical( filter.prefixPath, null );
  test.identical( filter.postfixPath, null );
  test.identical( filter.filePath, { '/src/*/a/b' : '', '/src/*/a/c' : true } );
  test.identical( filter.basePath, { '/src/*/a/b' : '/src' } );
  test.identical( filter.formedFilePath, { '/src' : '' } );
  test.identical( filter.formedBasePath, { '/src' : '/src' } );
  test.identical( filter.formed, 5 );

  test.case = 'base path and file path are relative, with glob, not only bools';
  var filter = provider.recordFilter();
  filter.prefixPath = '/src';
  filter.basePath = '.';
  filter.filePath = { 'a/b' : '', 'a/**.txt' : true };
  filter.form();
  test.identical( filter.prefixPath, null );
  test.identical( filter.postfixPath, null );
  test.identical( filter.filePath, { '/src/a/b' : '', '/src/a/**.txt' : true } );
  test.identical( filter.basePath, { '/src/a/b' : '/src' } );
  test.identical( filter.formedFilePath, { '/src/a/b' : '' } );
  test.identical( filter.formedBasePath, { '/src/a/b' : '/src' } );
  test.identical( filter.formed, 5 );

  if( Config.debug )
  {

    test.case = 'different base paths for the same file path';
    var filter = provider.recordFilter();
    filter.prefixPath = '/src/*';
    filter.basePath = { 'a/b' : '/src', 'a/c' : '/dst' };
    filter.filePath = { 'a/b' : true, 'a/c' : true };
    test.shouldThrowErrorSync( () => filter.form() );
    test.identical( filter.formed, 3 );
    test.identical( filter.formedFilePath, null );
    test.identical( filter.formedBasePath, null );
    test.identical( filter.filePath, { '/src/*/a/b' : true, '/src/*/a/c' : true } );
    test.identical( filter.basePath, { '/src/*/a/b' : '/src', '/src/*/a/c' : '/dst' } );
    test.identical( filter.prefixPath, null );
    test.identical( filter.postfixPath, null );

  }

  test.case = 'glob simplification';
  var filter = provider.recordFilter();
  filter.filePath = '/a/b/**';
  filter.form();
  test.identical( filter.formed, 5 );
  test.identical( filter.formedFilePath, { '/a/b' : '' } );
  test.identical( filter.formedBasePath, { '/a/b' : '/a/b' } );
  test.identical( filter.filePath, { '/a/b/**' : '' } );
  test.identical( filter.basePath, { '/a/b/**' : '/a/b' } );
  test.identical( filter.prefixPath, null );
  test.identical( filter.postfixPath, null );

  test.case = 'no glob simplification';
  var filter = provider.recordFilter();
  filter.filePath = '/a/**/b';
  filter.form();
  test.identical( filter.formed, 5 );
  test.identical( filter.formedFilePath, { '/a' : '' } );
  test.identical( filter.formedBasePath, { '/a' : '/a' } );
  test.identical( filter.filePath, { '/a/**/b' : '' } );
  test.identical( filter.basePath, { '/a/**/b' : '/a' } );
  test.identical( filter.prefixPath, null );
  test.identical( filter.postfixPath, null );

  test.case = 'base path is dot, absolute file paths';
  var filter = provider.recordFilter();
  filter.filePath = [ '/a/b/*x*', '/a/c/*x*' ];
  filter.basePath = '.';
  filter._formPaths();
  test.identical( filter.formed, 3 );
  test.identical( filter.formedFilePath, null );
  test.identical( filter.formedBasePath, null );
  test.identical( filter.filePath, { '/a/b/*x*' : '', '/a/c/*x*' : '' } );
  test.identical( filter.basePath, { '/a/b/*x*' : '/a/b', '/a/c/*x*' : '/a/c' } );
  test.identical( filter.prefixPath, null );
  test.identical( filter.postfixPath, null );

  test.case = 'base path is dot, relative file paths';
  var filter = provider.recordFilter();
  filter.filePath = [ 'a/b/*x*', 'a/c/*x*' ];
  filter.basePath = '.';
  filter._formPaths();
  test.identical( filter.formed, 3 );
  test.identical( filter.formedFilePath, null );
  test.identical( filter.formedBasePath, null );
  test.identical( filter.filePath, { 'a/b/*x*' : '', 'a/c/*x*' : '' } );
  test.identical( filter.basePath, { 'a/b/*x*' : 'a/b', 'a/c/*x*' : 'a/c' } );
  test.identical( filter.prefixPath, null );
  test.identical( filter.postfixPath, null );

  test.case = 'base path is empty, absolute file paths';
  var filter = provider.recordFilter();
  filter.filePath = [ '/a/b/*x*', '/a/c/*x*' ];
  filter.basePath = '';
  filter.form();
  test.identical( filter.formed, 5 );
  test.identical( filter.formedFilePath, { '/a/b' : '', '/a/c' : '' } );
  test.identical( filter.formedBasePath, { '/a/b' : '/a/b', '/a/c' : '/a/c' } );
  test.identical( filter.filePath, { '/a/b/*x*' : '', '/a/c/*x*' : '' } );
  test.identical( filter.basePath, { '/a/b/*x*' : '/a/b', '/a/c/*x*' : '/a/c' } );
  test.identical( filter.prefixPath, null );
  test.identical( filter.postfixPath, null );

  test.case = 'base path is empty, relative file paths';
  var filter = provider.recordFilter();
  filter.filePath = [ 'a/b/*x*', 'a/c/*x*' ];
  filter.basePath = '';
  filter._formPaths();
  test.identical( filter.formed, 3 );
  test.identical( filter.formedFilePath, null );
  test.identical( filter.formedBasePath, null );
  test.identical( filter.filePath, { 'a/b/*x*' : '', 'a/c/*x*' : '' } );
  test.identical( filter.basePath, { 'a/b/*x*' : 'a/b', 'a/c/*x*' : 'a/c' } );
  test.identical( filter.prefixPath, null );
  test.identical( filter.postfixPath, null );

  test.case = 'base path is string, file paths is empty array';
  var filter = provider.recordFilter();
  filter.filePath = [];
  filter.basePath = '/';
  filter.form();
  test.identical( filter.formed, 5 );
  test.identical( filter.formedFilePath, { '/' : '' } );
  test.identical( filter.formedBasePath, { '/' : '/' } );
  test.identical( filter.filePath, { '/' : '' } );
  test.identical( filter.basePath, { '/' : '/' } );
  test.identical( filter.prefixPath, null );
  test.identical( filter.postfixPath, null );

  test.case = 'base path is string, file paths is empty string';
  var filter = provider.recordFilter();
  filter.filePath = '';
  filter.basePath = '/';
  filter.form();
  test.identical( filter.formed, 5 );
  test.identical( filter.formedFilePath, { '/' : '' } );
  test.identical( filter.formedBasePath, { '/' : '/' } );
  test.identical( filter.filePath, { '/' : '' } );
  test.identical( filter.basePath, { '/' : '/' } );
  test.identical( filter.prefixPath, null );
  test.identical( filter.postfixPath, null );

  test.case = 'base path is string';
  var filter = provider.recordFilter();
  filter.basePath = '/';
  filter.form();
  test.identical( filter.formed, 5 );
  test.identical( filter.formedFilePath, { '/' : '' } );
  test.identical( filter.formedBasePath, { '/' : '/' } );
  test.identical( filter.filePath, { '/' : '' } );
  test.identical( filter.basePath, { '/' : '/' } );
  test.identical( filter.prefixPath, null );
  test.identical( filter.postfixPath, null );

  test.case = 'file path is map with only relative and only bools';
  var filter = provider.recordFilter();
  filter.filePath = { './src1/d**' : true, './src2/d/**' : true };
  filter.basePath = '/';
  filter.form();
  test.identical( filter.formed, 5 );
  test.identical( filter.formedFilePath, { '/src1' : '', '/src2/d' : '' } );
  test.identical( filter.formedBasePath, { '/src1' : '/', '/src2/d' : '/' } );
  test.identical( filter.filePath, { '/src1/d**' : true, '/src2/d/**' : true } );
  test.identical( filter.basePath, { '/src1/d**' : '/', '/src2/d/**' : '/' } );
  test.identical( filter.prefixPath, null );
  test.identical( filter.postfixPath, null );

  /* */

  test.case = 'paired, file path is map with only relative and only bools';
  var src = provider.recordFilter();
  src.filePath = { './src1/d**' : true, './src2/d/**' : true };
  src.basePath = '/';
  var dst = provider.recordFilter();
  src.pairWithDst( dst );
  src.pairRefineLight();

  test.is( src.filePath === dst.filePath );
  test.identical( src.filePath, { './src1/d**' : true, './src2/d/**' : true } );
  test.identical( src.prefixPath, null );
  test.identical( src.postfixPath, null );
  test.identical( src.basePath, '/' );
  test.identical( src.formed, 1 );
  test.identical( dst.filePath, { './src1/d**' : true, './src2/d/**' : true } );
  test.identical( dst.prefixPath, null );
  test.identical( dst.postfixPath, null );
  test.identical( dst.basePath, null );
  test.identical( dst.formed, 1 );

  dst.form();
  src.form();

  test.identical( src.formed, 5 );
  test.identical( src.formedFilePath, { '/src1' : '', '/src2/d' : '' } );
  test.identical( src.formedBasePath, { '/src1' : '/', '/src2/d' : '/' } );
  test.identical( src.filePath, { '/src1/d**' : true, '/src2/d/**' : true } );
  test.identical( src.basePath, { '/src1/d**' : '/', '/src2/d/**' : '/' } );
  test.identical( src.prefixPath, null );
  test.identical( src.postfixPath, null );

  test.identical( dst.formed, 5 );
  test.identical( dst.formedFilePath, { './src1' : true, './src2/d' : true } );
  test.identical( dst.formedBasePath, {} );
  test.identical( dst.filePath, { '/src1/d**' : true, '/src2/d/**' : true } );
  test.identical( dst.basePath, null );
  test.identical( dst.prefixPath, null );
  test.identical( dst.postfixPath, null );

  /* */

  test.case = 'paired, file path is map with only relative and only bools';
  var src = provider.recordFilter();
  src.filePath = { './src1/d**' : true, './src2/d/**' : true };
  src.basePath = '/';
  var dst = provider.recordFilter();
  dst.prefixPath = '/dst'
  src.pairWithDst( dst );
  src.pairRefineLight();

  test.is( src.filePath === dst.filePath );
  test.identical( src.filePath, { './src1/d**' : true, './src2/d/**' : true } );
  test.identical( src.prefixPath, null );
  test.identical( src.postfixPath, null );
  test.identical( src.basePath, '/' );
  test.identical( src.formed, 1 );
  test.identical( dst.filePath, { './src1/d**' : true, './src2/d/**' : true } );
  test.identical( dst.prefixPath, '/dst' );
  test.identical( dst.postfixPath, null );
  test.identical( dst.basePath, null );
  test.identical( dst.formed, 1 );

  dst.form();
  src.form();

  test.identical( src.formed, 5 );
  test.identical( src.formedFilePath, { '/src1' : '/dst', '/src2/d' : '/dst' } );
  test.identical( src.formedBasePath, { '/src1' : '/', '/src2/d' : '/' } );
  test.identical( src.filePath, { '/src1/d**' : '/dst', '/src2/d/**' : '/dst' } );
  test.identical( src.basePath, { '/src1/d**' : '/', '/src2/d/**' : '/' } );
  test.identical( src.prefixPath, null );
  test.identical( src.postfixPath, null );

  test.identical( dst.formed, 5 );
  test.identical( dst.formedFilePath, { './src1' : '/dst', './src2/d' : '/dst' } );
  test.identical( dst.formedBasePath, {} );
  test.identical( dst.filePath, { '/src1/d**' : '/dst', '/src2/d/**' : '/dst' } );
  test.identical( dst.basePath, null );
  test.identical( dst.prefixPath, null );
  test.identical( dst.postfixPath, null );

  /* */

  test.case = 'paired, file path is map with only relative and only bools, dst base path is empty map';
  var src = provider.recordFilter();
  src.filePath = { './src1/d**' : true, './src2/d/**' : true };
  src.basePath = '/';
  var dst = provider.recordFilter();
  dst.prefixPath = '/dst'
  dst.basePath = {};
  src.pairWithDst( dst );
  src.pairRefineLight();

  test.is( src.filePath === dst.filePath );
  test.identical( src.filePath, { './src1/d**' : true, './src2/d/**' : true } );
  test.identical( src.prefixPath, null );
  test.identical( src.postfixPath, null );
  test.identical( src.basePath, '/' );
  test.identical( src.formed, 1 );
  test.identical( dst.filePath, { './src1/d**' : true, './src2/d/**' : true } );
  test.identical( dst.prefixPath, '/dst' );
  test.identical( dst.postfixPath, null );
  test.identical( dst.basePath, {} );
  test.identical( dst.formed, 1 );

  dst.form();
  src.form();

  test.identical( src.formed, 5 );
  test.identical( src.formedFilePath, { '/src1' : '/dst', '/src2/d' : '/dst' } );
  test.identical( src.formedBasePath, { '/src1' : '/', '/src2/d' : '/' } );
  test.identical( src.filePath, { '/src1/d**' : '/dst', '/src2/d/**' : '/dst' } );
  test.identical( src.basePath, { '/src1/d**' : '/', '/src2/d/**' : '/' } );
  test.identical( src.prefixPath, null );
  test.identical( src.postfixPath, null );

  test.identical( dst.formed, 5 );
  test.identical( dst.formedFilePath, { './src1' : '/dst', './src2/d' : '/dst' } );
  test.identical( dst.formedBasePath, { '/dst' : '/dst' } );
  test.identical( dst.filePath, { '/src1/d**' : '/dst', '/src2/d/**' : '/dst' } );
  test.identical( dst.basePath, { '/dst' : '/dst' } );
  test.identical( dst.prefixPath, null );
  test.identical( dst.postfixPath, null );

  /* */

  test.case = 'paired, src.prefix, src.file, src.base, dst.prefix, dst.file';
  var src = provider.recordFilter();
  src.filePath = '/main/*';
  src.prefixPath = '/';
  src.basePath = '/main/';
  var dst = provider.recordFilter();
  dst.filePath = '.';
  dst.prefixPath = '/out/Main.s';
  src.pairWithDst( dst );
  src.pairRefineLight();

  test.is( src.filePath === dst.filePath );
  test.identical( src.filePath, { '/main/*' : '.' } );
  test.identical( src.prefixPath, '/' );
  test.identical( src.postfixPath, null );
  test.identical( src.basePath, '/main/' );
  test.identical( src.formed, 1 );
  test.identical( dst.filePath, { '/main/*' : '.' } );
  test.identical( dst.prefixPath, '/out/Main.s' );
  test.identical( dst.postfixPath, null );
  test.identical( dst.basePath, null );
  test.identical( dst.formed, 1 );

  dst.form();
  src.form();

  test.identical( src.formedFilePath, { '/main' : '/out/Main.s' } );
  test.identical( src.formedBasePath, { '/main' : '/main' } );
  test.identical( src.filePath, { '/main/*' : '/out/Main.s' } );
  test.identical( src.basePath, { '/main/*' : '/main' } );
  test.identical( src.prefixPath, null );
  test.identical( src.postfixPath, null );
  test.identical( src.formed, 5 );

  test.identical( dst.formedFilePath, { '/main' : '/out/Main.s' } );
  test.identical( dst.formedBasePath, {} );
  test.identical( dst.filePath, { '/main/*' : '/out/Main.s' } );
  test.identical( dst.basePath, null );
  test.identical( dst.prefixPath, null );
  test.identical( dst.postfixPath, null );
  test.identical( dst.formed, 5 );

  /* */

  test.case = 'paired, file path is map, prefixes paths are root';
  var src = provider.recordFilter();
  src.filePath = { 'src' : 'dst' };
  src.prefixPath =  '/';
  var dst = provider.recordFilter();
  dst.filePath = { 'src' : 'dst' };
  dst.prefixPath =  '/';
  src.pairWithDst( dst );
  src.pairRefineLight();

  test.is( src.filePath === dst.filePath );
  test.identical( src.filePath, { 'src' : 'dst' } );
  test.identical( src.prefixPath, '/' );
  test.identical( src.postfixPath, null );
  test.identical( src.basePath, null );
  test.identical( src.formed, 1 );
  test.identical( dst.filePath, { 'src' : 'dst' } );
  test.identical( dst.prefixPath, '/' );
  test.identical( dst.postfixPath, null );
  test.identical( dst.basePath, null );
  test.identical( dst.formed, 1 );

  dst.form();

  test.is( src.filePath === dst.filePath );
  test.identical( src.prefixPath, '/' );
  test.identical( src.postfixPath, null );
  test.identical( src.filePath, { 'src' : '/dst' } );
  test.identical( src.basePath, null );
  test.identical( src.formedFilePath, null );
  test.identical( src.formedBasePath, null );
  test.identical( src.formed, 1 );
  test.identical( dst.prefixPath, null );
  test.identical( dst.postfixPath, null );
  test.identical( dst.filePath, { 'src' : '/dst' } );
  test.identical( dst.basePath, null );
  test.identical( dst.formedFilePath, { 'src' : '/dst' } );
  test.identical( dst.formedBasePath, {} );
  test.identical( dst.formed, 5 );

  src.form();

  test.is( src.filePath === dst.filePath );
  test.identical( src.prefixPath, null );
  test.identical( src.postfixPath, null );
  test.identical( src.filePath, { '/src' : '/dst' } );
  test.identical( src.basePath, { '/src' : '/src' } );
  test.identical( src.formedFilePath, { '/src' : '/dst' } );
  test.identical( src.formedBasePath, { '/src' : '/src' } );
  test.identical( src.formed, 5 );
  test.identical( dst.prefixPath, null );
  test.identical( dst.postfixPath, null );
  test.identical( dst.filePath, { '/src' : '/dst' } );
  test.identical( dst.basePath, null );
  test.identical( dst.formedFilePath, { 'src' : '/dst' } );
  test.identical( dst.formedBasePath, {} );
  test.identical( dst.formed, 5 );

  /* */

  test.case = 'paired, dst file path is relative string, first dst';
  var src = provider.recordFilter();
  var dst = provider.recordFilter();
  dst.filePath = 'dst';
  src.pairWithDst( dst );
  src.pairRefineLight();

  test.is( src.filePath === dst.filePath );
  test.identical( src.filePath, { '' : 'dst' } );
  test.identical( src.prefixPath, null );
  test.identical( src.postfixPath, null );
  test.identical( src.basePath, null );
  test.identical( src.formed, 1 );
  test.identical( dst.filePath, { '' : 'dst' } );
  test.identical( dst.prefixPath, null );
  test.identical( dst.postfixPath, null );
  test.identical( dst.basePath, null );
  test.identical( dst.formed, 1 );

  dst._formMasks();

  test.is( src.filePath === dst.filePath );
  test.identical( src.prefixPath, null );
  test.identical( src.postfixPath, null );
  test.identical( src.filePath, { '' : 'dst' } );
  test.identical( src.basePath, null );
  test.identical( src.formedFilePath, null );
  test.identical( src.formedBasePath, null );
  test.identical( src.formed, 1 );
  test.identical( dst.prefixPath, null );
  test.identical( dst.postfixPath, null );
  test.identical( dst.filePath, { '' : 'dst' } );
  test.identical( dst.basePath, null );
  test.identical( dst.formedFilePath, { '' : 'dst' } );
  test.identical( dst.formedBasePath, {} );
  test.identical( dst.formed, 4 );

  src._formMasks();

  test.is( src.filePath === dst.filePath );
  test.identical( src.prefixPath, null );
  test.identical( src.postfixPath, null );
  test.identical( src.filePath, { '' : 'dst' } );
  test.identical( src.basePath, {} );
  test.identical( src.formedFilePath, { '' : 'dst' } );
  test.identical( src.formedBasePath, {} );
  test.identical( src.formed, 4 );
  test.identical( dst.prefixPath, null );
  test.identical( dst.postfixPath, null );
  test.identical( dst.filePath, { '' : 'dst' } );
  test.identical( dst.basePath, null );
  test.identical( dst.formedFilePath, { '' : 'dst' } );
  test.identical( dst.formedBasePath, {} );
  test.identical( dst.formed, 4 );

  /* */

  test.case = 'paired, dst file path is relative string, first src';
  var src = provider.recordFilter();
  var dst = provider.recordFilter();
  dst.filePath = 'dst';
  src.pairWithDst( dst );
  src.pairRefineLight();

  test.is( src.filePath === dst.filePath );
  test.identical( src.filePath, { '' : 'dst' } );
  test.identical( src.prefixPath, null );
  test.identical( src.postfixPath, null );
  test.identical( src.basePath, null );
  test.identical( src.formed, 1 );
  test.identical( dst.filePath, { '' : 'dst' } );
  test.identical( dst.prefixPath, null );
  test.identical( dst.postfixPath, null );
  test.identical( dst.basePath, null );
  test.identical( dst.formed, 1 );

  src._formMasks();

  test.is( src.filePath === dst.filePath );
  test.identical( src.prefixPath, null );
  test.identical( src.postfixPath, null );
  test.identical( src.filePath, { '' : 'dst' } );
  test.identical( src.basePath, {} );
  test.identical( src.formedFilePath, { '' : 'dst' } );
  test.identical( src.formedBasePath, {} );
  test.identical( src.formed, 4 );
  test.identical( dst.prefixPath, null );
  test.identical( dst.postfixPath, null );
  test.identical( dst.filePath, { '' : 'dst' } );
  test.identical( dst.basePath, null );
  test.identical( dst.formedFilePath, null );
  test.identical( dst.formedBasePath, null );
  test.identical( dst.formed, 1 );

  dst._formMasks();

  test.is( src.filePath === dst.filePath );
  test.identical( src.prefixPath, null );
  test.identical( src.postfixPath, null );
  test.identical( src.filePath, { '' : 'dst' } );
  test.identical( src.basePath, {} );
  test.identical( src.formedFilePath, { '' : 'dst' } );
  test.identical( src.formedBasePath, {} );
  test.identical( src.formed, 4 );
  test.identical( dst.prefixPath, null );
  test.identical( dst.postfixPath, null );
  test.identical( dst.filePath, { '' : 'dst' } );
  test.identical( dst.basePath, null );
  test.identical( dst.formedFilePath, { '' : 'dst' } );
  test.identical( dst.formedBasePath, {} );
  test.identical( dst.formed, 4 );

/*
  var src = provider.recordFilter();
  var dst = provider.recordFilter();
  dst.filePath = '/dst';
  src.pairWithDst( dst );
*/

}

//

function clone( test )
{
  let provider = _.fileProvider;
  let filter = new _.FileRecordFilter({ defaultFileProvider : provider });

  filter.prefixPath = '/some/path';

  filter.basePath =
  {
    '.module/mod/builder.coffee' : '.module/mod',
  }

  filter.filePath =
  {
    '.module/mod/builder.coffee' : '',
  }

  test.identical( filter.formed, 1 );

  let filter2 = filter.clone().form();
  let filter3 = filter.clone().form();
  filter.form();
  let filter4 = filter.clone();

  test.identical( filter.formed, 5 );
  test.identical( filter2.formed, 5 );
  test.identical( filter3.formed, 5 );
  test.identical( filter4.formed, 1 );

}

//

function isPaired( test )
{
  let provider = _.FileProvider.Extract();

  test.case = 'src and dst is paired';
  var src = provider.recordFilter({});
  var dst = provider.recordFilter({});
  src.pairWithDst( dst );
  test.is( src.isPaired() );
  test.is( dst.isPaired() );
  test.is( src.isPaired( dst ) );
  test.is( dst.isPaired( src ) );

  test.case = 'src and dst is paired, another filter is not paired';
  var src = provider.recordFilter({});
  var dst = provider.recordFilter({});
  var filter = provider.recordFilter({});
  src.pairWithDst( dst );
  test.is( src.isPaired() );
  test.is( dst.isPaired() );
  test.is( !filter.isPaired() );
  test.is( src.isPaired( dst ) );
  test.is( dst.isPaired( src ) );
  test.is( !src.isPaired( filter ) );
  test.is( !dst.isPaired( filter ) );
  test.is( !filter.isPaired( src ) );
  test.is( !filter.isPaired( dst ) );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'src and dst is paired to the same filter';
  var src = provider.recordFilter({});
  var dst = provider.recordFilter({});
  var filter = provider.recordFilter({});
  src.pairWithDst( filter );
  filter.pairWithDst( dst );
  test.shouldThrowErrorSync( () => src.isPaired() );

}

//

function reflect( test )
{

  var provider = _.FileProvider.Extract
  ({
    filesTree :
    {
      src :
      {
        f1: '1',
        d : { f2 : '2', f3 : '3' },
      },
      dst :
      {
        f1: 'dst',
        d : 'dst',
      }
    },
  });

  /* - */

  test.case = 'src and dst filters with prefixes and reflect map';

  var files = provider.filesReflect
  ({
    reflectMap : { 'src' : 'dst' },
    src : { prefixPath : '/' },
    dst : { prefixPath : '/' },
  });

  var expSrc = [ '/src', '/src/f1', '/src/d', '/src/d/f2', '/src/d/f3' ];
  var gotSrc = _.select( files, '*/src/absolute' );
  var expDst = [ '/src', '/src/f1', '/src/d', '/src/d/f2', '/src/d/f3' ];
  var gotDst = _.select( files, '*/src/absolute' );

  test.identical( gotSrc, expSrc );
  test.identical( gotDst, expDst );

  /* - */

  test.case = 'src filter with prefixes and reflect map';

  var files = provider.filesReflect
  ({
    reflectMap : { 'src' : '/dst' },
    src : { prefixPath : '/' },
  });

  var expSrc = [ '/src', '/src/f1', '/src/d', '/src/d/f2', '/src/d/f3' ];
  var gotSrc = _.select( files, '*/src/absolute' );
  var expDst = [ '/src', '/src/f1', '/src/d', '/src/d/f2', '/src/d/f3' ];
  var gotDst = _.select( files, '*/src/absolute' );

  test.identical( gotSrc, expSrc );
  test.identical( gotDst, expDst );

  /* - */

  test.case = 'dst filter with prefixes and reflect map';

  var files = provider.filesReflect
  ({
    reflectMap : { '/src' : 'dst' },
    dst : { prefixPath : '/' },
  });

  var expSrc = [ '/src', '/src/f1', '/src/d', '/src/d/f2', '/src/d/f3' ];
  var gotSrc = _.select( files, '*/src/absolute' );
  var expDst = [ '/src', '/src/f1', '/src/d', '/src/d/f2', '/src/d/f3' ];
  var gotDst = _.select( files, '*/src/absolute' );

  test.identical( gotSrc, expSrc );
  test.identical( gotDst, expDst );

  /* */

  if( !Config.debug )
  return;

  /* */

  test.description = 'cant deduce base path';

  test.shouldThrowError( () =>
  {
    provider.filesReflect
    ({
      reflectMap : { 'src' : 'dst' },
    });
  });

  test.shouldThrowError( () =>
  {
    provider.filesReflect
    ({
      reflectMap : { 'src' : 'dst' },
      src : { prefixPath : '/' },
    });
  });

  test.shouldThrowError( () =>
  {
    provider.filesReflect
    ({
      reflectMap : { 'src' : 'dst' },
      dst : { prefixPath : '/' },
    });
  });

}

//

function prefixesApply( test )
{
  let context = this;
  let provider = new _.FileProvider.Extract();
  let path = provider.path;

  /* - */

  test.open( 'single' );

  /* - */

  test.case = 'trivial';

  var f1 = provider.recordFilter({});
  var expectedBasePath = '/dir/filter1/proto';
  var expectedFilePath = { '/dir/filter1/f' : '', '/dir/filter1/d' : '', '/dir/filter1/ex' : false }

  f1.filePath = { 'f' : null, 'd' : null, 'ex' : false }
  f1.prefixPath = '/dir/filter1';
  f1.basePath = './proto';

  f1.prefixesApply();

  test.identical( f1.prefixPath, null );
  test.identical( f1.basePath, expectedBasePath );
  test.identical( f1.filePath, expectedFilePath );

  /* */

  test.case = 'trivial, dots, but prefix';

  var f1 = provider.recordFilter({});
  var expectedBasePath = 'app';
  var expectedFilePath = 'app';

  f1.filePath = '.';
  f1.prefixPath = 'app';
  f1.basePath = '.';

  f1.prefixesApply();

  test.identical( f1.prefixPath, null );
  test.identical( f1.basePath, expectedBasePath );
  test.identical( f1.filePath, expectedFilePath );

  /* */

  test.case = 'string prefix path, file path is map with only true and only relative, booleanFallingBack:1, basePath is empty map';

  var f1 = provider.recordFilter({});
  var expectedBasePath = { '/dst/src1/d**' : '/dst/src1', '/dst/src2/d/**' : '/dst/src2/d' };
  var expectedFilePath = { '/dst/src1/d**' : true, '/dst/src2/d/**' : true };

  f1.filePath = { '/dst/src1/d**' : true, '/dst/src2/d/**' : true };
  f1.prefixPath = '/dst';
  f1.basePath = {};

  f1.prefixesApply({ booleanFallingBack : 1 });

  test.identical( f1.prefixPath, null );
  test.identical( f1.basePath, expectedBasePath );
  test.identical( f1.filePath, expectedFilePath );

  /* */

  test.case = 'string prefix path, file path is map with only true and only relative';

  var f1 = provider.recordFilter({});
  var expectedBasePath = null;
  var expectedFilePath = { '/dst/src1/d**' : true, '/dst/src2/d/**' : true, '/dst' : '' };

  f1.filePath = { './src1/d**' : true, './src2/d/**' : true };
  f1.prefixPath = '/dst';

  f1.prefixesApply();

  test.identical( f1.prefixPath, null );
  test.identical( f1.basePath, expectedBasePath );
  test.identical( f1.filePath, expectedFilePath );

  /* */

  test.case = 'only booleans';

  var f1 = provider.recordFilter({});
  var expectedBasePath = { '/dir/**' : '/dir/base', '/dir/doubledir/d1/**' : '/dir/doubledir/d1/base' };
  var expectedFilePath =
  {
    '/dir/**' : '',
    '/dir/doubledir/d1/**' : '',
    '/dir/**/**b**' : false,
    '/dir/doubledir/d1/**/**b**' : false,
  };

  f1.filePath = { '.' : true, '**b**' : false };
  f1.prefixPath = [ '/dir/**', '/dir/doubledir/d1/**' ];
  f1.basePath = './base';

  f1.prefixesApply();

  test.identical( f1.prefixPath, null );
  test.identical( f1.basePath, expectedBasePath );
  test.identical( f1.filePath, expectedFilePath );

  /* */

  test.case = 'only booleans, booleanFallingBack:1';

  var f1 = provider.recordFilter({});
  var expectedBasePath =
  {
    '/dir/doubledir/d1/**/dir2' : '/dir/doubledir/d1/base',
    '/dir/**/dir2' : '/dir/base',
    // '/dir/doubledir/d1/**' : '/dir/doubledir/d1/base',
    // '/dir/**' : '/dir/base',
    // '/dir/doubledir/d1/**/dir2' : '/dir/doubledir/d1/base',
    // '/dir/**/dir2' : '/dir/base',
  };
  var expectedFilePath =
  {
    '/dir/doubledir/d1/**/dir2' : true,
    '/dir/**/dir2' : true,
    '/dir/doubledir/d1/**/**b**' : false,
    '/dir/**/**b**' : false,
    // '/dir/doubledir/d1/**/dir2' : true,
    // '/dir/**/dir2' : true,
    // '/dir/doubledir/d1/**/**b**' : false,
    // '/dir/**/**b**' : false,
    // '/dir/doubledir/d1/**' : '',
    // '/dir/**' : ''
  }
  f1.filePath = { 'dir2' : true, '**b**' : false };
  f1.prefixPath = [ '/dir/doubledir/d1/**', '/dir/**' ];
  f1.basePath = './base';

  f1.prefixesApply({ booleanFallingBack : 1 });

  test.identical( f1.prefixPath, null );
  test.identical( f1.basePath, expectedBasePath );
  test.identical( f1.filePath, expectedFilePath );

  /* */

  test.case = 'only booleans, booleanFallingBack:1';

  var f1 = provider.recordFilter({});
  var expectedBasePath =
  {
    '/dir/doubledir/d1/**/**b**' : '/dir/doubledir/d1/base',
    '/dir/**/**b**' : '/dir/base',
  }
  var expectedFilePath =
  {
    '/dir/doubledir/d1/**' : false,
    '/dir/**' : false,
    '/dir/doubledir/d1/**/**b**' : true,
    '/dir/**/**b**' : true
  }

  f1.filePath = { '.' : false, '**b**' : true };
  f1.prefixPath = [ '/dir/doubledir/d1/**', '/dir/**' ];
  f1.basePath = './base';

  f1.prefixesApply({ booleanFallingBack : 1 });

  test.identical( f1.prefixPath, null );
  test.identical( f1.basePath, expectedBasePath );
  test.identical( f1.filePath, expectedFilePath );

  /* */

  test.case = 'file path is map with dot true and false';

  var f1 = provider.recordFilter({});
  var expectedBasePath =
  {
    '/dir/doubledir/d1/**' : '/dir/doubledir/d1/base',
    '/dir/**' : '/dir/base',
  };
  var expectedFilePath =
  {
    '/dir/doubledir/d1/**' : '',
    '/dir/**' : '',
    '/dir/doubledir/d1/**/**b**' : false,
    '/dir/**/**b**' : false,
  };

  f1.filePath = { '.' : true, '**b**' : false };
  f1.prefixPath = [ '/dir/doubledir/d1/**', '/dir/**' ];
  f1.basePath = './base';

  f1.prefixesApply();

  test.identical( f1.prefixPath, null );
  test.identical( f1.basePath, expectedBasePath );
  test.identical( f1.filePath, expectedFilePath );

  /* */

  test.case = 'file path is map with dot true and false, booleanFallingBack:1';

  var f1 = provider.recordFilter({});
  var expectedBasePath =
  {
    '/dir/doubledir/d1/**' : '/dir/doubledir/d1/base',
    '/dir/**' : '/dir/base',
  };
  var expectedFilePath =
  {
    '/dir/doubledir/d1/**' : true,
    '/dir/**' : true,
    '/dir/doubledir/d1/**/**b**' : false,
    '/dir/**/**b**' : false,
  };

  f1.filePath = { '.' : true, '**b**' : false };
  f1.prefixPath = [ '/dir/doubledir/d1/**', '/dir/**' ];
  f1.basePath = './base';

  f1.prefixesApply({ booleanFallingBack : 1 });

  test.identical( f1.prefixPath, null );
  test.identical( f1.basePath, expectedBasePath );
  test.identical( f1.filePath, expectedFilePath );

  /* */

  test.case = 'file path is map with dot true and false, applyingToTrue:1';

  var f1 = provider.recordFilter({});
  var expectedBasePath =
  {
    '/dir/doubledir/d1/**' : '/dir/doubledir/d1/base',
    '/dir/**' : '/dir/base',
  };
  var expectedFilePath =
  {
    '/dir/doubledir/d1/**' : true,
    '/dir/**' : true,
    '/dir/doubledir/d1/**/**b**' : false,
    '/dir/**/**b**' : false,
  };

  f1.filePath = { '.' : true, '**b**' : false };
  f1.prefixPath = [ '/dir/doubledir/d1/**', '/dir/**' ];
  f1.basePath = './base';

  f1.prefixesApply({ booleanFallingBack : 0, applyingToTrue : 1 });

  test.identical( f1.prefixPath, null );
  test.identical( f1.basePath, expectedBasePath );
  test.identical( f1.filePath, expectedFilePath );

  /* */

  test.case = 'multiple globs';

  var f1 = provider.recordFilter({});
  var expectedBasePath = { '/dir/d1/**' : '/dir/d1/d11', '/dir/d2/**' : '/dir/d2/d11' };
  var expectedFilePath = { '/dir/**b**' : false, '/dir/d1/**' : '', '/dir/d2/**' : '' };

  f1.filePath = { '/dir/**b**' : false };
  f1.prefixPath = [ '/dir/d1/**', '/dir/d2/**' ];
  f1.basePath = './d11';

  f1.prefixesApply();

  test.identical( f1.prefixPath, null );
  test.identical( f1.basePath, expectedBasePath );
  test.identical( f1.filePath, expectedFilePath );

  /* */

  test.case = 'drops redundant base path';

  var f1 = provider.recordFilter({});
  var expectedBasePath = '/dir/d1/d11';
  var expectedFilePath = { '/dir/**b**' : '' };

  f1.filePath = { '/dir/**b**' : '' };
  f1.prefixPath = [ '/dir/d1/**', '/dir/d2/**' ];
  f1.basePath = './d11';

  f1.prefixesApply();

  test.identical( f1.prefixPath, null );
  test.identical( f1.basePath, expectedBasePath );
  test.identical( f1.filePath, expectedFilePath );

  /* */

  test.case = 'prefix with glob';

  var f1 = provider.recordFilter({});
  var expectedBasePath = 'app';
  var expectedFilePath = 'app/**';

  f1.filePath = '.';
  f1.prefixPath = 'app/**';
  f1.basePath = '.';

  f1.prefixesApply();

  test.identical( f1.prefixPath, null );
  test.identical( f1.basePath, expectedBasePath );
  test.identical( f1.filePath, expectedFilePath );

  /* */

  test.case = 'file path is map with single element, base path is map, prefix';

  var f1 = provider.recordFilter({});
  var expectedBasePath = '/some/path/.module/mod';
  var expectedFilePath = { '/some/path/.module/mod/builder.coffee' : '' };

  f1.filePath =
  {
    '.module/mod/builder.coffee' : '',
  }
  f1.prefixPath = '/some/path';
  f1.basePath =
  {
    '.module/mod/builder.coffee' : '.module/mod',
  }

  f1.prefixesApply();

  test.identical( f1.prefixPath, null );
  test.identical( f1.basePath, expectedBasePath );
  test.identical( f1.filePath, expectedFilePath );

  /* */

  test.case = 'file path is map with only true, no base path, prefix';

  var f1 = provider.recordFilter({});
  var expectedBasePath = null;
  var expectedFilePath = { '/some/path/.module/mod/builder.coffee' : true, '/some/path' : '' };

  f1.filePath =
  {
    '.module/mod/builder.coffee' : true,
  }
  f1.prefixPath = '/some/path';

  f1.prefixesApply();

  test.identical( f1.prefixPath, null );
  test.identical( f1.basePath, expectedBasePath );
  test.identical( f1.filePath, expectedFilePath );

  /* */

  test.case = 'file path is map with only true, base path is empty map, prefix';

  var f1 = provider.recordFilter({});
  var expectedBasePath = '/some/path';
  var expectedFilePath = { '/some/path/.module/mod/builder.coffee' : true, '/some/path' : '' };

  f1.filePath =
  {
    '.module/mod/builder.coffee' : true,
  }
  f1.prefixPath = '/some/path';
  f1.basePath =
  {
  }

  f1.prefixesApply();

  test.identical( f1.prefixPath, null );
  test.identical( f1.basePath, expectedBasePath );
  test.identical( f1.filePath, expectedFilePath );

  /* */

  test.case = 'file path is map with only true, base path is map, prefix';

  var f1 = provider.recordFilter({});
  var expectedBasePath = '/some/path/.module/mod';
  var expectedFilePath = { '/some/path/.module/mod/builder.coffee' : true, '/some/path' : '' };

  f1.filePath =
  {
    '.module/mod/builder.coffee' : true,
  }
  f1.prefixPath = '/some/path';
  f1.basePath =
  {
    '/some/path' : '.module/mod',
  }

  f1.prefixesApply();

  test.identical( f1.prefixPath, null );
  test.identical( f1.basePath, expectedBasePath );
  test.identical( f1.filePath, expectedFilePath );

  /* */

  test.case = 'file path is map with only true, base path is illformed map, prefix';

  var f1 = provider.recordFilter({});
  var expectedBasePath = '/some/path/.module/mod';
  var expectedFilePath = '/some/path/.module/mod/builder.coffee';

  f1.filePath =
  {
    '.module/mod/builder.coffee' : true,
  }
  f1.prefixPath = '/some/path';
  f1.basePath =
  {
    '.module/mod/builder.coffee' : '.module/mod',
  }

  test.shouldThrowErrorSync( () =>
  {

    f1.prefixesApply();

    test.identical( f1.prefixPath, null );
    test.identical( f1.basePath, expectedBasePath );
    test.identical( f1.filePath, expectedFilePath );

  });

  /* */

  test.case = 'prefix with glob, base is map, file is map';

  var f1 = provider.recordFilter({});
  var expectedBasePath = { 'app/**/f1' : 'app/base1', 'app/**/f2' : 'app/base2' };
  var expectedFilePath = [ 'app/**/f1', 'app/**/f2' ];

  f1.filePath = [ 'f1', 'f2' ];
  f1.prefixPath = 'app/**';
  f1.basePath = { 'f1' : 'base1', 'f2' : 'base2' };

  f1.prefixesApply();

  test.identical( f1.prefixPath, null );
  test.identical( f1.basePath, expectedBasePath );
  test.identical( f1.filePath, expectedFilePath );

  /* */

  test.case = 'prefix with glob, base is map';

  var f1 = provider.recordFilter({});
  var expectedBasePath = 'app/app2';
  var expectedFilePath = 'app/**/f';

  f1.filePath = 'f';
  f1.prefixPath = 'app/**';
  f1.basePath = { 'f' : 'app2' };

  f1.prefixesApply();

  test.identical( f1.prefixPath, null );
  test.identical( f1.basePath, expectedBasePath );
  test.identical( f1.filePath, expectedFilePath );

  /* */

  test.case = 'prefixPathOnly';

  var f1 = provider.recordFilter({});

  f1.filePath = null;
  f1.prefixPath = '/dir/filter1';
  f1.basePath = null;

  f1.prefixesApply();

  test.identical( f1.prefixPath, null );
  test.identical( f1.basePath, null );
  test.identical( f1.filePath, '/dir/filter1' );

  /* */

  test.case = 'no filePath, but basePath';

  var f1 = provider.recordFilter({});

  f1.filePath = null;
  f1.prefixPath = '/dir/filter1';
  f1.basePath = './proto';

  f1.prefixesApply();

  test.identical( f1.prefixPath, null );
  test.identical( f1.basePath, '/dir/filter1/proto' );
  test.identical( f1.filePath, '/dir/filter1' );

  /* */

  test.case = 'filePath is empty map';

  var f1 = provider.recordFilter({});
  var expectedBasePath = '/dir/filter1/proto';
  var expectedFilePath = '/dir/filter1';

  f1.filePath = {};
  f1.prefixPath = '/dir/filter1';
  f1.basePath = './proto';

  f1.prefixesApply();

  test.identical( f1.prefixPath, null );
  test.identical( f1.basePath, expectedBasePath );
  test.identical( f1.filePath, expectedFilePath );

  /* */

  test.case = 'trivial, only bools';

  var f1 = provider.recordFilter({});
  var expectedBasePath = '/dir/filter1/proto';
  var expectedFilePath = { '/dir/filter1' : '', '/dir/filter1/f' : true, '/dir/filter1/d' : true, '/dir/filter1/ex' : false }

  f1.filePath = { '/dir/filter1/f' : true, '/dir/filter1/d' : true, '/dir/filter1/ex' : false }
  f1.prefixPath = '/dir/filter1';
  f1.basePath = './proto';

  f1.prefixesApply();

  test.identical( f1.prefixPath, null );
  test.identical( f1.basePath, expectedBasePath );
  test.identical( f1.filePath, expectedFilePath );

  /* */

  test.case = 'trivial, only bools, booleanFallingBack:1';

  var f1 = provider.recordFilter({});
  var expectedBasePath = '/dir/filter1/proto';
  var expectedFilePath = { '/dir/filter1/f' : true, '/dir/filter1/d' : true, '/dir/filter1/ex' : false }

  f1.filePath = { '/dir/filter1/f' : true, '/dir/filter1/d' : true, '/dir/filter1/ex' : false }
  f1.prefixPath = '/dir/filter1';
  f1.basePath = './proto';

  f1.prefixesApply({ booleanFallingBack : 1 });

  test.identical( f1.prefixPath, null );
  test.identical( f1.basePath, expectedBasePath );
  test.identical( f1.filePath, expectedFilePath );

  /* */

  test.case = 'base path is relative and current';

  var f1 = provider.recordFilter();
  var expectedBasePath = '/dir/filter1';
  var expectedFilePath = { '/dir/filter1/f' : '', '/dir/filter1/ex' : false }

  f1.filePath = { 'f' : null, 'ex' : false }
  f1.prefixPath = '/dir/filter1'
  f1.basePath = '.';

  f1.prefixesApply();

  test.identical( f1.prefixPath, null );
  test.identical( f1.basePath, expectedBasePath );
  test.identical( f1.filePath, expectedFilePath );

  /* */

  test.case = 'no base path';

  var f1 = provider.recordFilter();
  var expectedBasePath = null;
  var expectedFilePath = { '/dir/filter1/f' : '', '/dir/filter1/ex' : false }

  f1.filePath = { 'f' : null, 'ex' : false }
  f1.prefixPath = '/dir/filter1'
  f1.basePath = null;

  f1.prefixesApply();

  test.identical( f1.prefixPath, null );
  test.identical( f1.basePath, expectedBasePath );
  test.identical( f1.filePath, expectedFilePath );

  /* */

  test.case = 'prefix is relative';

  var f1 = provider.recordFilter();
  var expectedBasePath = '/base';
  var expectedFilePath = { './dir/f' : '', './dir/ex' : false }

  f1.filePath = { 'f' : null, 'ex' : false }
  f1.prefixPath = './dir'
  f1.basePath = '/base';

  f1.prefixesApply();

  test.identical( f1.prefixPath, null );
  test.identical( f1.basePath, expectedBasePath );
  test.identical( f1.filePath, expectedFilePath );

  /* */

  test.case = 'some in file paths are absolute';

  var f1 = provider.recordFilter();
  var expectedBasePath = '/dir/filter1/proto';
  var expectedFilePath = { '/dir/filter1/d' : '', '/dir/filter1/f' : '', '/dir/ex' : false }

  f1.filePath = { 'f' : null, '/dir/filter1/d' : null, '/dir/ex' : false }
  f1.prefixPath = '/dir/filter1'
  f1.basePath = './proto';

  f1.prefixesApply();

  test.identical( f1.prefixPath, null );
  test.identical( f1.basePath, expectedBasePath );
  test.identical( f1.filePath, expectedFilePath );

  /* */

  test.case = 'base path is absolute';

  var f1 = provider.recordFilter();
  var expectedBasePath = '/proto';
  var expectedFilePath = { '/dir/filter1/d' : '', '/dir/filter1/f' : '', '/dir/ex' : false }

  f1.filePath = { 'f' : null, '/dir/filter1/d' : null, '/dir/ex' : false }
  f1.prefixPath = '/dir/filter1'
  f1.basePath = '/proto';

  f1.prefixesApply();

  test.identical( f1.prefixPath, null );
  test.identical( f1.basePath, expectedBasePath );
  test.identical( f1.filePath, expectedFilePath );

  /* */

  test.case = 'prefix is glob';

  var f1 = provider.recordFilter();
  var expectedBasePath = '/src';
  var expectedFilePath = { '/src/*/a/b' : true, '/src/*/a/c' : true, '/src/*' : '' }

  f1.prefixPath = '/src/*';
  f1.filePath = { 'a/b' : true, 'a/c' : true };
  f1.basePath = { 'a/b' : '/src', 'a/c' : '/dst' };

  f1.prefixesApply();

  test.identical( f1.prefixPath, null );
  test.identical( f1.basePath, expectedBasePath );
  test.identical( f1.filePath, expectedFilePath );

  /* */

  test.case = 'prefix is glob, booleanFallingBack : 1';

  var f1 = provider.recordFilter();
  var expectedBasePath = { '/src/*/a/b' : '/src', '/src/*/a/c' : '/dst' };
  var expectedFilePath = { '/src/*/a/b' : true, '/src/*/a/c' : true }

  f1.prefixPath = '/src/*';
  f1.filePath = { 'a/b' : true, 'a/c' : true };
  f1.basePath = { 'a/b' : '/src', 'a/c' : '/dst' };

  f1.prefixesApply({ booleanFallingBack : 1 });

  test.identical( f1.prefixPath, null );
  test.identical( f1.basePath, expectedBasePath );
  test.identical( f1.filePath, expectedFilePath );

  /* - */

  test.close( 'single' );
  test.open( 'source' );

  /* - */

  test.case = 'trivial';

  var src = provider.recordFilter();
  var dst = provider.recordFilter();
  src.pairWithDst( dst );
  var expectedBasePath = '/dir/filter1/proto';
  var expectedFilePath = { '/dir/filter1/f' : '', '/dir/filter1/d' : '', '/dir/filter1/ex' : false }

  src.filePath = { 'f' : null, 'd' : null, 'ex' : false }
  src.prefixPath = '/dir/filter1'
  src.basePath = './proto';

  src.prefixesApply();

  test.identical( src.prefixPath, null );
  test.identical( src.basePath, expectedBasePath );
  test.identical( src.filePath, expectedFilePath );

  /* */

  test.case = 'base path is relative and current';

  var src = provider.recordFilter();
  var dst = provider.recordFilter();
  src.pairWithDst( dst );
  var expectedBasePath = '/dir/filter1';
  var expectedFilePath = { '/dir/filter1/f' : '', '/dir/filter1/ex' : false }

  src.filePath = { 'f' : null, 'ex' : false }
  src.prefixPath = '/dir/filter1'
  src.basePath = '.';

  src.prefixesApply();

  test.identical( src.prefixPath, null );
  test.identical( src.basePath, expectedBasePath );
  test.identical( src.filePath, expectedFilePath );

  /* */

  test.case = 'no base path';

  var src = provider.recordFilter();
  var dst = provider.recordFilter();
  src.pairWithDst( dst );
  var expectedBasePath = null;
  var expectedFilePath = { '/dir/filter1/f' : '', '/dir/filter1/ex' : false }

  src.filePath = { 'f' : null, 'ex' : false }
  src.prefixPath = '/dir/filter1'
  src.basePath = null;

  src.prefixesApply();

  test.identical( src.prefixPath, null );
  test.identical( src.basePath, expectedBasePath );
  test.identical( src.filePath, expectedFilePath );

  /* */

  test.case = 'prefix is relative';

  var src = provider.recordFilter();
  var dst = provider.recordFilter();
  src.pairWithDst( dst );
  var expectedBasePath = '/base';
  var expectedFilePath = { './dir/f' : '', './dir/ex' : false }

  src.filePath = { 'f' : null, 'ex' : false }
  src.prefixPath = './dir'
  src.basePath = '/base';

  src.prefixesApply();

  test.identical( src.prefixPath, null );
  test.identical( src.basePath, expectedBasePath );
  test.identical( src.filePath, expectedFilePath );

  /* */

  test.case = 'some in file paths are absolute';

  var src = provider.recordFilter();
  var dst = provider.recordFilter();
  src.pairWithDst( dst );
  var expectedBasePath = '/dir/filter1/proto';
  var expectedFilePath = { '/dir/filter1/f' : '', '/dir/filter1/d' : '', '/dir/ex' : false }

  src.filePath = { 'f' : '', '/dir/filter1/d' : '', '/dir/ex' : false }
  src.prefixPath = '/dir/filter1'
  src.basePath = './proto';

  src.prefixesApply();

  test.identical( src.prefixPath, null );
  test.identical( src.basePath, expectedBasePath );
  test.identical( src.filePath, expectedFilePath );

  /* */

  test.case = 'base path is absolute';

  var src = provider.recordFilter();
  var dst = provider.recordFilter();
  src.pairWithDst( dst );

  var expectedBasePath = '/proto';
  var expectedFilePath = { '/dir/filter1/f' : '', '/dir/filter1/d' : '', '/dir/ex' : false }

  src.filePath = { 'f' : null, '/dir/filter1/d' : null, '/dir/ex' : false }
  src.prefixPath = '/dir/filter1'
  src.basePath = '/proto';

  src.prefixesApply();

  test.identical( src.prefixPath, null );
  test.identical( src.basePath, expectedBasePath );
  test.identical( src.filePath, expectedFilePath );

  /* */

  test.case = 'no filePath';

  var src = provider.recordFilter();
  var dst = provider.recordFilter();
  src.pairWithDst( dst );
  src.prefixPath = '/dir/filter1';
  src.basePath = './proto';
  src.prefixesApply();

  test.identical( src.prefixPath, null );
  test.identical( src.postfixPath, null );
  test.identical( src.basePath, '/dir/filter1/proto' );
  test.identical( src.filePath, { '/dir/filter1' : '' } );

  /* - */

  test.close( 'source' );
  test.open( 'destination' );

  /* - */

  test.case = 'trivial';

  var src = provider.recordFilter();
  var dst = provider.recordFilter();
  src.pairWithDst( dst );
  var expectedBasePath = '/dir/filter1/proto';
  var expectedFilePath = { 'f' : '/dir/filter1', 'd' : '/dir/filter1', 'ex' : false }

  dst.filePath = { 'f' : null, 'd' : null, 'ex' : false }
  dst.prefixPath = '/dir/filter1';
  dst.basePath = './proto';

  dst.prefixesApply();

  test.identical( dst.prefixPath, null );
  test.identical( dst.basePath, expectedBasePath );
  test.identical( dst.filePath, expectedFilePath );

  /* */

  test.case = 'string prefix path, file path is map with only true and only relative, booleanFallingBack:1';

  var dst = provider.recordFilter({});
  var src = provider.recordFilter({});
  src.pairWithDst( dst );
  var expectedBasePath = null;
  var expectedFilePath = { './src1/d**' : '/dst', './src2/d/**' : '/dst' };

  dst.filePath = { './src1/d**' : true, './src2/d/**' : true };
  dst.prefixPath = '/dst';

  dst.prefixesApply({ booleanFallingBack : 1 });

  test.identical( dst.prefixPath, null );
  test.identical( dst.basePath, expectedBasePath );
  test.identical( dst.filePath, expectedFilePath );

  test.case = 'string prefix path, file path is map with only true and only relative, booleanFallingBack:1, dst.basePath is empty map';

  var dst = provider.recordFilter({});
  var src = provider.recordFilter({});
  src.pairWithDst( dst );
  var expectedBasePath = '/dst';
  var expectedFilePath = { './src1/d**' : '/dst', './src2/d/**' : '/dst' };

  dst.filePath = { './src1/d**' : true, './src2/d/**' : true };
  dst.prefixPath = '/dst';
  dst.basePath = {};

  dst.prefixesApply({ booleanFallingBack : 1 });

  test.identical( dst.prefixPath, null );
  test.identical( dst.basePath, expectedBasePath );
  test.identical( dst.filePath, expectedFilePath );

  test.case = 'string prefix path, file path is map with only true and only relative';

  var dst = provider.recordFilter({});
  var src = provider.recordFilter({});
  src.pairWithDst( dst );
  var expectedBasePath = null;
  var expectedFilePath = { './src1/d**' : true, './src2/d/**' : true, 'ex' : false, '' : '/dst' };

  dst.filePath = { './src1/d**' : true, './src2/d/**' : true, 'ex' : false };
  dst.prefixPath = '/dst';

  dst.prefixesApply();

  test.identical( dst.prefixPath, null );
  test.identical( dst.basePath, expectedBasePath );
  test.identical( dst.filePath, expectedFilePath );

  /* */

  test.case = 'base path is relative and current';

  var src = provider.recordFilter();
  var dst = provider.recordFilter();
  src.pairWithDst( dst );
  var expectedBasePath = '/dir/filter1';
  var expectedFilePath = { 'f' : '/dir/filter1', 'ex' : false }

  dst.filePath = { 'f' : null, 'ex' : false }
  dst.prefixPath = '/dir/filter1';
  dst.basePath = '.';

  dst.prefixesApply();

  test.identical( dst.prefixPath, null );
  test.identical( dst.basePath, expectedBasePath );
  test.identical( dst.filePath, expectedFilePath );

  /* */

  test.case = 'no base path';

  var src = provider.recordFilter();
  var dst = provider.recordFilter();
  src.pairWithDst( dst );
  var expectedBasePath = null;
  var expectedFilePath = { 'f' : '/dir/filter1', 'ex' : false }

  dst.filePath = { 'f' : null, 'ex' : false }
  dst.prefixPath = '/dir/filter1'
  dst.basePath = null;

  dst.prefixesApply();

  test.identical( dst.prefixPath, null );
  test.identical( dst.basePath, expectedBasePath );
  test.identical( dst.filePath, expectedFilePath );

  /* */

  test.case = 'prefix is relative';

  var src = provider.recordFilter();
  var dst = provider.recordFilter();
  src.pairWithDst( dst );
  var expectedBasePath = '/base';
  var expectedFilePath = { 'f' : './dir/dir', 'ex' : false }

  dst.filePath = { 'f' : './dir', 'ex' : false }
  dst.prefixPath = './dir'
  dst.basePath = '/base';

  dst.prefixesApply();

  test.identical( dst.prefixPath, null );
  test.identical( dst.basePath, expectedBasePath );
  test.identical( dst.filePath, expectedFilePath );

  /* */

  test.case = 'some in file paths are absolute';

  var src = provider.recordFilter();
  var dst = provider.recordFilter();
  src.pairWithDst( dst );
  var expectedBasePath = '/dir/filter1/proto';
  var expectedFilePath = { 'f' : '/dir/filter1', '/dir/filter1/d' : '/dir/filter1', '/dir/ex' : false }

  dst.filePath = { 'f' : null, '/dir/filter1/d' : null, '/dir/ex' : false }
  dst.prefixPath = '/dir/filter1';
  dst.basePath = './proto';

  dst.prefixesApply();

  test.identical( dst.prefixPath, null );
  test.identical( dst.basePath, expectedBasePath );
  test.identical( dst.filePath, expectedFilePath );

  /* */

  test.case = 'base path is absolute';

  var src = provider.recordFilter();
  var dst = provider.recordFilter();
  src.pairWithDst( dst );
  var expectedBasePath = '/proto';
  var expectedFilePath = { 'f' : '/dir/filter1', '/dir/filter1/d' : '/dir/filter1', '/dir/ex' : false }

  dst.filePath = { 'f' : null, '/dir/filter1/d' : null, '/dir/ex' : false }
  dst.prefixPath = '/dir/filter1';
  dst.basePath = '/proto';

  dst.prefixesApply();

  test.identical( dst.prefixPath, null );
  test.identical( dst.basePath, expectedBasePath );
  test.identical( dst.filePath, expectedFilePath );

  /* */

  test.case = 'no filePath';

  var src = provider.recordFilter();
  var dst = provider.recordFilter();
  src.pairWithDst( dst );
  dst.prefixPath = '/dir/filter1';
  dst.basePath = './proto';

  dst.prefixesApply();

  test.identical( dst.prefixPath, null );
  test.identical( dst.postfixPath, null );
  test.identical( dst.basePath, '/dir/filter1/proto' );
  test.identical( dst.filePath, { '' : '/dir/filter1' } );

  test.identical( src.prefixPath, null );
  test.identical( src.postfixPath, null );
  test.identical( src.basePath, null );
  test.identical( src.filePath, { '' : '/dir/filter1' } );

  /* - */

  test.close( 'destination' );

  /* - */

  test.open( 'no file path' );

  /* */

  test.case = 'prefix paths, src.prefixesApply first';

  var src = provider.recordFilter();
  var dst = provider.recordFilter();
  src.pairWithDst( dst );
  dst.prefixPath = '/dst';
  dst.basePath = null;
  src.prefixPath = '/src';
  src.basePath = null;

  src.prefixesApply();
  dst.prefixesApply();

  test.identical( dst.prefixPath, null );
  test.identical( dst.postfixPath, null );
  test.identical( dst.basePath, null );
  test.identical( dst.filePath, { '/src' : '/dst' } );
  test.identical( src.prefixPath, null );
  test.identical( src.postfixPath, null );
  test.identical( src.basePath, null );
  test.identical( src.filePath, { '/src' : '/dst' } );

  /* */

  test.case = 'prefix paths, dst.prefixesApply first';

  var src = provider.recordFilter();
  var dst = provider.recordFilter();
  src.pairWithDst( dst );
  dst.prefixPath = '/dst';
  dst.basePath = null;
  src.prefixPath = '/src';
  src.basePath = null;

  dst.prefixesApply();
  src.prefixesApply();

  test.identical( dst.prefixPath, null );
  test.identical( dst.postfixPath, null );
  test.identical( dst.basePath, null );
  test.identical( dst.filePath, { '/src' : '/dst' } );
  test.identical( src.prefixPath, null );
  test.identical( src.postfixPath, null );
  test.identical( src.basePath, null );
  test.identical( src.filePath, { '/src' : '/dst' } );

  /* */

  test.case = 'prefix array paths, src.prefixesApply first';

  var src = provider.recordFilter();
  var dst = provider.recordFilter();
  src.pairWithDst( dst );
  dst.prefixPath = '/dst';
  dst.basePath = null;
  src.prefixPath = [ '/src1', '/src2' ];
  src.basePath = null;

  src.prefixesApply();
  dst.prefixesApply();

  test.identical( dst.prefixPath, null );
  test.identical( dst.postfixPath, null );
  test.identical( dst.basePath, null );
  test.identical( dst.filePath, { '/src1' : '/dst', '/src2' : '/dst' } );
  test.identical( src.prefixPath, null );
  test.identical( src.postfixPath, null );
  test.identical( src.basePath, null );
  test.identical( src.filePath, { '/src1' : '/dst', '/src2' : '/dst' } );

  /* */

  test.case = 'prefix paths + base paths, src.prefixesApply first';

  var src = provider.recordFilter();
  var dst = provider.recordFilter();
  src.pairWithDst( dst );
  dst.prefixPath = '/dst';
  dst.basePath = 'dbase';
  src.prefixPath = '/src';
  src.basePath = 'sbase';

  src.prefixesApply();
  dst.prefixesApply();

  test.identical( dst.prefixPath, null );
  test.identical( dst.postfixPath, null );
  test.identical( dst.basePath, '/dst/dbase' );
  test.identical( dst.filePath, { '/src' : '/dst' } );
  test.identical( src.prefixPath, null );
  test.identical( src.postfixPath, null );
  test.identical( src.basePath, '/src/sbase' );
  test.identical( src.filePath, { '/src' : '/dst' } );

  /* */

  test.case = 'prefix paths + base paths, dst.prefixesApply first';

  var src = provider.recordFilter();
  var dst = provider.recordFilter();
  src.pairWithDst( dst );
  dst.prefixPath = '/dst';
  dst.basePath = 'dbase';
  src.prefixPath = '/src';
  src.basePath = 'sbase';

  dst.prefixesApply();
  src.prefixesApply();

  test.identical( dst.prefixPath, null );
  test.identical( dst.postfixPath, null );
  test.identical( dst.basePath, '/dst/dbase' );
  test.identical( dst.filePath, { '/src' : '/dst' } );
  test.identical( src.prefixPath, null );
  test.identical( src.postfixPath, null );
  test.identical( src.basePath, '/src/sbase' );
  test.identical( src.filePath, { '/src' : '/dst' } );

  /* - */

  test.close( 'no file path' );

}

//

function prefixesRelative( test )
{
  let provider = _.fileProvider;

  /* */

  test.case = 'file path - map, single';
  var osrc =
  {
    filePath : { '/src' : '/dst' }
  }
  var src = provider.recordFilter( osrc );
  src.prefixesRelative();

  test.identical( src.formed, 1 );
  test.identical( src.filePath, { '.' : '../dst' } );
  test.identical( src.prefixPath, '/src' );

  /* */

  test.case = 'file path - map with empty str dst and abs src';
  var osrc =
  {
    filePath : { '/src' : '' }
  }
  var src = provider.recordFilter( osrc );
  src.prefixesRelative();

  test.identical( src.formed, 1 );
  test.identical( src.filePath, { '.' : '' } );
  test.identical( src.prefixPath, '/src' );

  /* */

  test.case = 'file path - map with empty str dst and dot src';
  var osrc =
  {
    filePath : { '.' : '' }
  }
  var src = provider.recordFilter( osrc );
  src.prefixesRelative();

  test.identical( src.formed, 1 );
  test.identical( src.filePath, { '.' : '' } );
  test.identical( src.prefixPath, '.' );

  /* */

  test.case = 'file path - map, single, src relative';
  var osrc =
  {
    filePath : { './src' : '/dst' }
  }
  var src = provider.recordFilter( osrc );
  src.prefixesRelative();

  test.identical( src.formed, 1 );
  test.identical( src.filePath, { '.' : '/dst' } );
  test.identical( src.prefixPath, './src' );

  /* */

  test.case = 'file path - map, single, dst relative';
  var osrc =
  {
    filePath : { '/src' : './dst' }
  }
  var src = provider.recordFilter( osrc );
  src.prefixesRelative();

  test.identical( src.formed, 1 );
  test.identical( src.filePath, { '.' : './dst' } );
  test.identical( src.prefixPath, '/src' );

  /* */

  test.case = 'file path - map, single, dst is true';
  var osrc =
  {
    filePath : { '/src/a' : true, '/src/b' : '/dst/b' }
  }
  var src = provider.recordFilter( osrc );
  src.prefixesRelative();

  test.identical( src.formed, 1 );
  test.identical( src.filePath, { 'a' : true, 'b' : '../dst/b' } );
  test.identical( src.prefixPath, '/src' );

  /* */

  test.case = 'file path - map';
  var osrc =
  {
    filePath : { '/src' : '/dst' }
  }
  var odst =
  {
    filePath : osrc.filePath
  }
  var src = provider.recordFilter( osrc );
  var dst = provider.recordFilter( odst );
  src.filePath = dst.filePath;
  test.is( src.filePath === dst.filePath );
  src.pairWithDst( dst );
  test.is( src.filePath === dst.filePath );

  src.prefixesRelative();
  test.identical( src.formed, 1 );
  test.identical( src.filePath, { '.' : '/dst' } );
  test.identical( src.prefixPath, '/src' );
  test.identical( dst.formed, 1 );
  test.identical( dst.filePath, { '.' : '/dst' } );
  test.identical( dst.prefixPath, null );
  test.is( src.filePath === dst.filePath );

  dst.prefixesRelative();
  test.identical( src.formed, 1 );
  test.identical( src.filePath, { '.' : '.' } );
  test.identical( src.prefixPath, '/src' );
  test.identical( dst.formed, 1 );
  test.identical( dst.filePath, { '.' : '.' } );
  test.identical( dst.prefixPath, '/dst' );
  test.is( src.filePath === dst.filePath );

  /* */

  test.case = 'file path is abs map, src base path is child abs string';
  var src = provider.recordFilter();
  src.filePath = { '/module/proto' : '/dst' };
  src.basePath = '/module/proto/module';
  var dst = provider.recordFilter();
  src.pairWithDst( dst );
  src.pairRefineLight();
  test.is( src.filePath === dst.filePath );

  src.prefixesRelative();
  test.identical( src.formed, 1 );
  test.identical( src.filePath, { '.' : '/dst' } );
  test.identical( src.basePath, 'module' );
  test.identical( src.prefixPath, '/module/proto' );
  test.identical( dst.formed, 1 );
  test.identical( dst.filePath, { '.' : '/dst' } );
  test.identical( dst.basePath, null );
  test.identical( dst.prefixPath, null );
  test.is( src.filePath === dst.filePath );

  dst.prefixesRelative();
  test.identical( src.formed, 1 );
  test.identical( src.filePath, { '.' : '.' } );
  test.identical( src.basePath, 'module' );
  test.identical( src.prefixPath, '/module/proto' );
  test.identical( dst.formed, 1 );
  test.identical( dst.filePath, { '.' : '.' } );
  test.identical( dst.basePath, null );
  test.identical( dst.prefixPath, '/dst' );
  test.is( src.filePath === dst.filePath );

  /* */

  test.case = 'file path is abs map, src base path is parent abs string';
  var src = provider.recordFilter();
  src.filePath = { '/module/proto' : '/dst' };
  src.basePath = '/module';
  var dst = provider.recordFilter();
  src.pairWithDst( dst );
  src.pairRefineLight();
  test.is( src.filePath === dst.filePath );

  src.prefixesRelative();
  test.identical( src.formed, 1 );
  test.identical( src.filePath, { '.' : '/dst' } );
  test.identical( src.basePath, '..' );
  test.identical( src.prefixPath, '/module/proto' );
  test.identical( dst.formed, 1 );
  test.identical( dst.filePath, { '.' : '/dst' } );
  test.identical( dst.basePath, null );
  test.identical( dst.prefixPath, null );
  test.is( src.filePath === dst.filePath );

  dst.prefixesRelative();
  test.identical( src.formed, 1 );
  test.identical( src.filePath, { '.' : '.' } );
  test.identical( src.basePath, '..' );
  test.identical( src.prefixPath, '/module/proto' );
  test.identical( dst.formed, 1 );
  test.identical( dst.filePath, { '.' : '.' } );
  test.identical( dst.basePath, null );
  test.identical( dst.prefixPath, '/dst' );
  test.is( src.filePath === dst.filePath );

  /* */

  test.case = 'file path - map';
  var osrc =
  {
    filePath : { '.' : '' }
  }
  var odst =
  {
    filePath : osrc.filePath
  }
  var src = provider.recordFilter( osrc );
  var dst = provider.recordFilter( odst );
  src.filePath = dst.filePath;
  test.is( src.filePath === dst.filePath );
  src.pairWithDst( dst );
  test.is( src.filePath === dst.filePath );

  src.prefixesRelative();
  test.identical( src.formed, 1 );
  test.identical( src.filePath, { '.' : '' } );
  test.identical( src.prefixPath, '.' );
  test.identical( dst.formed, 1 );
  test.identical( dst.filePath, { '.' : '' } );
  test.identical( dst.prefixPath, null );
  test.is( src.filePath === dst.filePath );

  debugger;
  dst.prefixesRelative();
  debugger;
  test.identical( src.formed, 1 );
  test.identical( src.filePath, { '.' : '' } );
  test.identical( src.prefixPath, '.' );
  test.identical( dst.formed, 1 );
  test.identical( dst.filePath, { '.' : '' } );
  test.identical( dst.prefixPath, null );
  test.is( src.filePath === dst.filePath );

  /* */

  test.case = 'file path - map, with bools';
  var osrc =
  {
    filePath : { '/src/a' : '/dst', '/src/b' : true }
  }
  var odst =
  {
    filePath : osrc.filePath
  }
  var src = provider.recordFilter( osrc );
  var dst = provider.recordFilter( odst );
  src.filePath = dst.filePath;
  test.is( src.filePath === dst.filePath );
  src.pairWithDst( dst );
  test.is( src.filePath === dst.filePath );

  src.prefixesRelative();
  test.identical( src.formed, 1 );
  test.identical( src.filePath, { 'a' : '/dst', 'b' : true } );
  test.identical( src.prefixPath, '/src' );
  test.identical( dst.formed, 1 );
  test.identical( dst.filePath, { 'a' : '/dst', 'b' : true } );
  test.identical( dst.prefixPath, null );
  test.is( src.filePath === dst.filePath );

  dst.prefixesRelative();
  test.identical( src.formed, 1 );
  test.identical( src.filePath, { 'a' : '.', 'b' : true } );
  test.identical( src.prefixPath, '/src' );
  test.identical( dst.formed, 1 );
  test.identical( dst.filePath, { 'a' : '.', 'b' : true } );
  test.identical( dst.prefixPath, '/dst' );
  test.is( src.filePath === dst.filePath );

  /* */

  test.case = 'file path - absolute map, prefix path - absolute string, base path - absolute map, no argument';
  var osrc =
  {
    filePath : { '/src' : '/dst' },
    prefixPath : '/srcPrefix',
    basePath : { '/src' : '/srcPrefix' },
  }
  var odst =
  {
    filePath : { '/src' : '/dst' },
    prefixPath : '/dstPrefix',
    basePath : { '/dst' : '/dstPrefix' },
  }
  var src = provider.recordFilter( osrc );
  var dst = provider.recordFilter( odst );
  src.filePath = dst.filePath;
  test.is( src.filePath === dst.filePath );
  src.pairWithDst( dst );
  test.is( src.filePath === dst.filePath );

  src.prefixesRelative();
  test.identical( src.formed, 1 );
  test.identical( src.filePath, { '../src' : '/dst' } );
  test.identical( src.prefixPath, '/srcPrefix' );
  test.identical( src.basePath, { '../src' : '.' } );
  test.identical( dst.formed, 1 );
  test.identical( dst.filePath, { '../src' : '/dst' } );
  test.identical( dst.prefixPath, '/dstPrefix' );
  test.identical( dst.basePath, { '/dst' : '/dstPrefix' } );
  test.is( src.filePath === dst.filePath );

  dst.prefixesRelative();
  test.identical( src.formed, 1 );
  test.identical( src.filePath, { '../src' : '../dst' } );
  test.identical( src.prefixPath, '/srcPrefix' );
  test.identical( src.basePath, { '../src' : '.' } );
  test.identical( dst.formed, 1 );
  test.identical( dst.filePath, { '../src' : '../dst' } );
  test.identical( dst.prefixPath, '/dstPrefix' );
  test.identical( dst.basePath, { '../dst' : '.' } );
  test.is( src.filePath === dst.filePath );

  /* */

  test.case = 'file path - absolute map, base path - absolute map, argument';
  var osrc =
  {
    filePath : { '/src' : '/dst' },
    prefixPath :  null,
    basePath : { '/src' : '/srcPrefix' },
  }
  var odst =
  {
    filePath : { '/src' : '/dst' },
    prefixPath : null,
    basePath : { '/dst' : '/dstPrefix' },
  }
  var src = provider.recordFilter( osrc );
  var dst = provider.recordFilter( odst );
  src.filePath = dst.filePath;
  test.is( src.filePath === dst.filePath );
  src.pairWithDst( dst );
  test.is( src.filePath === dst.filePath );

  src.prefixesRelative( '/srcPrefix' );
  test.identical( src.formed, 1 );
  test.identical( src.filePath, { '../src' : '/dst' } );
  test.identical( src.prefixPath, '/srcPrefix' );
  test.identical( src.basePath, { '../src' : '.' } );
  test.identical( dst.formed, 1 );
  test.identical( dst.filePath, { '../src' : '/dst' } );
  test.identical( dst.prefixPath, null );
  test.identical( dst.basePath, { '/dst' : '/dstPrefix' } );
  test.is( src.filePath === dst.filePath );

  dst.prefixesRelative( '/dstPrefix' );
  test.identical( src.formed, 1 );
  test.identical( src.filePath, { '../src' : '../dst' } );
  test.identical( src.prefixPath, '/srcPrefix' );
  test.identical( src.basePath, { '../src' : '.' } );
  test.identical( dst.formed, 1 );
  test.identical( dst.filePath, { '../src' : '../dst' } );
  test.identical( dst.prefixPath, '/dstPrefix' );
  test.identical( dst.basePath, { '../dst' : '.' } );
  test.is( src.filePath === dst.filePath );

  /* */

  test.case = 'file path - relative map, prefix path - absolute string, base path - relative map, no argument';
  var osrc =
  {
    filePath : { '../src' : '../dst' },
    prefixPath : '/srcPrefix',
    basePath : { '../src' : '.' },
  }
  var odst =
  {
    filePath : { '../src' : '../dst' },
    prefixPath : '/dstPrefix',
    basePath : { '../dst' : '.' },
  }
  var src = provider.recordFilter( osrc );
  var dst = provider.recordFilter( odst );
  src.filePath = dst.filePath;
  test.is( src.filePath === dst.filePath );
  src.pairWithDst( dst );
  test.is( src.filePath === dst.filePath );

  src.prefixesRelative();
  test.identical( src.formed, 1 );
  test.identical( src.filePath, { '../src' : '../dst' } );
  test.identical( src.prefixPath, '/srcPrefix' );
  test.identical( src.basePath, { '../src' : '.' } );
  test.identical( dst.formed, 1 );
  test.identical( dst.filePath, { '../src' : '../dst' } );
  test.identical( dst.prefixPath, '/dstPrefix' );
  test.identical( dst.basePath, { '../dst' : '.' } );
  test.is( src.filePath === dst.filePath );

  dst.prefixesRelative();
  test.identical( src.formed, 1 );
  test.identical( src.filePath, { '../src' : '../dst' } );
  test.identical( src.prefixPath, '/srcPrefix' );
  test.identical( src.basePath, { '../src' : '.' } );
  test.identical( dst.formed, 1 );
  test.identical( dst.filePath, { '../src' : '../dst' } );
  test.identical( dst.prefixPath, '/dstPrefix' );
  test.identical( dst.basePath, { '../dst' : '.' } );
  test.is( src.filePath === dst.filePath );

  /* */

  test.case = 'file path - relative map, prefix path - absolute string, base path - relative map, no argument';
  var osrc =
  {
  }
  var odst =
  {
    filePath : '/a/b',
    basePath : '/a/b',
  }
  var src = provider.recordFilter( osrc );
  var dst = provider.recordFilter( odst );
  src.pairWithDst( dst );
  test.identical( src.filePath, null );
  test.identical( dst.filePath, '/a/b' );

  dst.prefixesRelative();
  test.identical( src.formed, 1 );
  test.identical( src.filePath, { '' : '.' } );
  test.identical( src.prefixPath, null );
  test.identical( src.basePath, null );
  test.identical( dst.formed, 1 );
  test.identical( dst.filePath, { '' : '.' } );
  test.identical( dst.prefixPath, '/a/b' );
  test.identical( dst.basePath, '.' );
  test.is( src.filePath === dst.filePath );

  /* */

  test.case = 'file path - map, single, dst is true';
  var osrc =
  {
    filePath : { '**.test** ' : false }
  }
  var src = provider.recordFilter( osrc );
  src.prefixesRelative();

  test.identical( src.formed, 1 );
  test.identical( src.filePath, { '**.test** ' : false } );
  test.identical( src.prefixPath, '.' );
  test.identical( src.basePath, null );

}

//

/*
please duplicate all test cases in pathsExtend, pathsExtendJoing, pathsInherit
qqq : please make sure it's so
*/

function pathsExtend( test )
{
  let context = this;
  let provider = new _.FileProvider.Extract();
  let path = provider.path;

  /* filePath */

  test.case = 'src.filePath is relative path ( string )';
  var dst = provider.recordFilter();
  var src = provider.recordFilter();
  src.filePath = 'b';
  dst.pathsExtend( src );

  test.identical( dst.prefixPath, null );
  test.identical( dst.filePath, 'b' );
  test.identical( dst.basePath, null );
  test.identical( src.prefixPath, null );
  test.identical( src.filePath, 'b' );
  test.identical( src.basePath, null );

  test.case = 'src.filePath is relative path ( string ), dst.filePath is relative path ( string )';
  var dst = provider.recordFilter();
  dst.filePath = 'a';
  var src = provider.recordFilter();
  src.filePath = 'b';
  dst.pathsExtend( src );

  test.identical( dst.prefixPath, null );
  test.identical( dst.filePath, { 'a' : '', 'b' : '' } );
  test.identical( dst.basePath, null );
  test.identical( src.prefixPath, null );
  test.identical( src.filePath, 'b' );
  test.identical( src.basePath, null );

  /* - */

  test.case = 'src.filePath is absolute path ( string )';
  var dst = provider.recordFilter();
  var src = provider.recordFilter();
  src.filePath = '/b';
  dst.pathsExtend( src );

  test.identical( dst.prefixPath, null );
  test.identical( dst.filePath, '/b' );
  test.identical( dst.basePath, null );
  test.identical( src.prefixPath, null );
  test.identical( src.filePath, '/b' );
  test.identical( src.basePath, null );

  test.case = 'src.filePath is absolute path ( string ), dst.filePath is absolute path ( string )';
  var dst = provider.recordFilter();
  dst.filePath = '/a';
  var src = provider.recordFilter();
  src.filePath = '/b';
  dst.pathsExtend( src );

  test.identical( dst.prefixPath, null );
  test.identical( dst.filePath, { '/a' : '', '/b' : '' } );
  test.identical( dst.basePath, null );
  test.identical( src.prefixPath, null );
  test.identical( src.filePath, '/b' );
  test.identical( src.basePath, null );

  /* - */

  test.case = 'src.filePath is absolute path ( string ), dst.filePath is absolute path ( map )';
  var dst = provider.recordFilter();
  dst.filePath = { '/a' : '' };
  var src = provider.recordFilter();
  src.filePath = '/b';
  dst.pathsExtend( src );

  test.identical( dst.prefixPath, null );
  test.identical( dst.filePath, { '/a' : '', '/b' : '' } );
  test.identical( dst.basePath, null );
  test.identical( src.prefixPath, null );
  test.identical( src.filePath, '/b' );
  test.identical( src.basePath, null );

  /* - */

  test.case = 'src.filePath is absolute path ( map )';
  var dst = provider.recordFilter();
  var src = provider.recordFilter();
  src.filePath = { '/b' : '' };
  dst.pathsExtend( src );

  test.identical( dst.prefixPath, null );
  test.identical( dst.filePath, { '/b' : '' } );
  test.identical( dst.basePath, null );
  test.identical( src.prefixPath, null );
  test.identical( src.filePath, { '/b' : '' } );
  test.identical( src.basePath, null );

  test.case = 'src.filePath is absolute path ( map ), dst.filePath is absolute path ( string )';
  var dst = provider.recordFilter();
  dst.filePath = '/a';
  var src = provider.recordFilter();
  src.filePath = { '/b' : '' };
  dst.pathsExtend( src );

  test.identical( dst.prefixPath, null );
  test.identical( dst.filePath, { '/a' : '', '/b' : '' } );
  test.identical( dst.basePath, null );
  test.identical( src.prefixPath, null );
  test.identical( src.filePath, { '/b' : '' } );
  test.identical( src.basePath, null );

  /* - */

  test.case = 'src.filePath is relative path ( map ), dst.filePath is map with bools';
  var dst = provider.recordFilter();
  dst.filePath = { 'node_modules' : 0, 'package.json' : 0, '*.js' : 1 };
  var src = provider.recordFilter();
  src.filePath = { 'dir' : '' };
  dst.pathsExtend( src );

  test.identical( dst.prefixPath, null );
  test.identical( dst.filePath, { 'dir' : '', 'node_modules' : false, 'package.json' : false, '*.js' : true } );
  test.identical( dst.basePath, null );
  test.identical( src.prefixPath, null );
  test.identical( src.filePath, { 'dir' : '' } );
  test.identical( src.basePath, null );

  /* - */

  test.case = 'src.filePath is map with bools';
  var dst = provider.recordFilter();
  var src = provider.recordFilter();
  src.filePath = { 'node_modules' : false, 'package.json' : false, '*.js' : true };
  dst.pathsExtend( src );

  test.identical( dst.prefixPath, null );
  test.identical( dst.filePath, { 'node_modules' : false, 'package.json' : false, '*.js' : true } );
  test.identical( dst.basePath, null );
  test.identical( src.prefixPath, null );
  test.identical( src.filePath, { 'node_modules' : false, 'package.json' : false, '*.js' : true } );
  test.identical( src.basePath, null );

  test.case = 'src.filePath is relative path ( string ), dst.filePath is relative path ( string )';
  var dst = provider.recordFilter();
  dst.filePath = { 'dir' : '' };
  var src = provider.recordFilter();
  src.filePath = { 'node_modules' : false, 'package.json' : false, '*.js' : true };
  dst.pathsExtend( src );

  test.identical( dst.prefixPath, null );
  test.identical( dst.filePath, { 'dir' : '', 'node_modules' : false, 'package.json' : false, '*.js' : true } );
  test.identical( dst.basePath, null );
  test.identical( src.prefixPath, null );
  test.identical( src.filePath, { 'node_modules' : false, 'package.json' : false, '*.js' : true } );
  test.identical( src.basePath, null );

  /* basPath */

  test.case = 'src.basePath is string';
  var dst = provider.recordFilter();
  var src = provider.recordFilter();
  src.basePath = 'src/base';
  dst.pathsExtend( src );

  test.identical( dst.prefixPath, null );
  test.identical( dst.filePath, null );
  test.identical( dst.basePath, 'src/base' );
  test.identical( src.prefixPath, null );
  test.identical( src.filePath, null );
  test.identical( src.basePath, 'src/base' );

  test.case = 'src.basePath is string, dst.basePath is string';
  var dst = provider.recordFilter();
  dst.basePath = 'dst/base';
  var src = provider.recordFilter();
  src.basePath = 'src/base';
  dst.pathsExtend( src );

  test.identical( dst.prefixPath, null );
  test.identical( dst.filePath, null );
  test.identical( dst.basePath, 'src/base' );
  test.identical( src.prefixPath, null );
  test.identical( src.filePath, null );
  test.identical( src.basePath, 'src/base' );

  /* - */

  test.case = 'src.basePath is string, dst.basePath is map';
  var dst = provider.recordFilter();
  dst.basePath = { '.' : 'dst/base' };
  var src = provider.recordFilter();
  src.basePath = 'src/base';
  dst.pathsExtend( src );

  test.identical( dst.prefixPath, null );
  test.identical( dst.filePath, null );
  test.identical( dst.basePath, 'src/base' );
  test.identical( src.prefixPath, null );
  test.identical( src.filePath, null );
  test.identical( src.basePath, 'src/base' );

  /* - */

  test.case = 'src.basePath is map';
  var dst = provider.recordFilter();
  var src = provider.recordFilter();
  src.basePath = { '.' : 'src/base' };
  dst.pathsExtend( src );

  test.identical( dst.prefixPath, null );
  test.identical( dst.filePath, null );
  test.identical( dst.basePath, { '.' : 'src/base' } );
  test.identical( src.prefixPath, null );
  test.identical( src.filePath, null );
  test.identical( src.basePath, { '.' : 'src/base' } );

  test.case = 'src.basePath is map, dst.basePath is string';
  var dst = provider.recordFilter();
  dst.basePath = 'dst/base';
  var src = provider.recordFilter();
  src.basePath = { '.' : 'src/base' };
  dst.pathsExtend( src );

  test.identical( dst.prefixPath, null );
  test.identical( dst.filePath, null );
  test.identical( dst.basePath, { '.' : 'src/base' } );
  test.identical( src.prefixPath, null );
  test.identical( src.filePath, null );
  test.identical( src.basePath, { '.' : 'src/base' } );

  /* - */

  test.case = 'src.basePath is string, dst.basePath is map, collision';
  var dst = provider.recordFilter();
  dst.basePath = { '.' : 'dst/base' };
  var src = provider.recordFilter();
  src.basePath = { '.' : 'src/base' };
  dst.pathsExtend( src );

  test.identical( dst.prefixPath, null );
  test.identical( dst.filePath, null );
  test.identical( dst.basePath, { '.' : 'src/base' } );
  test.identical( src.prefixPath, null );
  test.identical( src.filePath, null );
  test.identical( src.basePath, { '.' : 'src/base' } );

  /* - */

  test.case = 'src.basePath is string, dst.basePath is map, not collision';
  var dst = provider.recordFilter();
  dst.basePath = { 'dst' : 'dst/base' };
  var src = provider.recordFilter();
  src.basePath = { 'src' : 'src/base' };
  dst.pathsExtend( src );

  test.identical( dst.prefixPath, null );
  test.identical( dst.filePath, null );
  test.identical( dst.basePath, { 'src' : 'src/base', 'dst' : 'dst/base' } );
  test.identical( src.prefixPath, null );
  test.identical( src.filePath, null );
  test.identical( src.basePath, { 'src' : 'src/base' } );

  /* prefixPath, basePath, filePath */

  test.case = 'full src form, src.filePath has only bools, full dst form, dst.filePath has only bools';
  var dst = provider.recordFilter();
  dst.prefixPath = '/commonDir/filter1';
  dst.basePath = './proto';
  dst.filePath = { 'f' : true, 'd' : true, 'ex' : false, 'f1' : true, 'd1' : true, 'ex1' : false, 'ex3' : true };
  var src = provider.recordFilter();
  src.prefixPath = '/commonDir/filter2';
  src.basePath = './proto';
  src.filePath = { 'f' : true, 'd' : true, 'ex' : false, 'f2' : true, 'd2' : true, 'ex2' : false, 'ex3' : false };
  dst.pathsExtend( src );

  var expectedDstFilePath =
  {
    '/commonDir/filter1/f' : true,
    '/commonDir/filter1/d' : true,
    '/commonDir/filter1/ex' : false,
    '/commonDir/filter1/f1' : true,
    '/commonDir/filter1/d1' : true,
    '/commonDir/filter1/ex1' : false,
    '/commonDir/filter1/ex3' : true,
    '/commonDir/filter1' : '',
    '/commonDir/filter2/f' : true,
    '/commonDir/filter2/d' : true,
    '/commonDir/filter2/ex' : false,
    '/commonDir/filter2/f2' : true,
    '/commonDir/filter2/d2' : true,
    '/commonDir/filter2/ex2' : false,
    '/commonDir/filter2/ex3' : false,
    '/commonDir/filter2' : ''
  };
  var expectedDstBasePath =
  {
    '/commonDir/filter1' : '/commonDir/filter1/proto',
    '/commonDir/filter2' : '/commonDir/filter2/proto'
  };
  var expectedSrcFilePath =
  {
    '/commonDir/filter2/f' : true,
    '/commonDir/filter2/d' : true,
    '/commonDir/filter2/ex' : false,
    '/commonDir/filter2/f2' : true,
    '/commonDir/filter2/d2' : true,
    '/commonDir/filter2/ex2' : false,
    '/commonDir/filter2/ex3' : false,
    '/commonDir/filter2' : ''
  };

  test.identical( dst.prefixPath, null );
  test.identical( dst.filePath, expectedDstFilePath );
  test.identical( dst.basePath, expectedDstBasePath );
  test.identical( src.prefixPath, null );
  test.identical( src.filePath, expectedSrcFilePath );
  test.identical( src.basePath, '/commonDir/filter2/proto' );

  /* - */

  test.case = 'full src form, src.prefixPath is array, src.filePath has relative paths, only bools';
  var dst = provider.recordFilter();
  dst.basePath = '/dir';
  var src = provider.recordFilter();
  src.prefixPath = [ '/dir/doubledir/d1/**', '/dir/**' ];
  src.basePath = './base';
  src.filePath = { '.' : true, '**b**' : false };
  dst.pathsExtend( src );

  var expectedDstFilePath =
  {
    '/dir/doubledir/d1/**' : '',
    '/dir/**' : '',
    '/dir/doubledir/d1/**/**b**' : false,
    '/dir/**/**b**' : false,
  };
  var expectedDstBasePath =
  {
    '/dir/doubledir/d1/**' : '/dir/doubledir/d1/base',
    '/dir/**' : '/dir/base',
  };

  test.identical( dst.prefixPath, null );
  test.identical( dst.filePath, expectedDstFilePath );
  test.identical( dst.basePath, expectedDstBasePath );
  test.identical( src.prefixPath, null );
  test.identical( src.filePath, expectedDstFilePath );
  test.identical( src.basePath, expectedDstBasePath );

  /* - */

  test.case = 'full src form, src.prefixPath is array, src.filePath has absolute path with bool';
  var dst = provider.recordFilter();
  dst.basePath = '/dir';
  var src = provider.recordFilter();
  src.prefixPath = [ '/dir/d1/**', '/dir/d2/**' ];
  src.basePath = './d11';
  src.filePath = { '/dir/**b**' : false };
  dst.pathsExtend( src );

  var expectedDstFilePath =
  {
    '/dir/**b**' : false,
    '/dir/d1/**' : '',
    '/dir/d2/**' : '',
  };
  var expectedDstBasePath =
  {
    '/dir/d1/**' : '/dir/d1/d11',
    '/dir/d2/**' : '/dir/d2/d11',
  };

  test.identical( dst.prefixPath, null );
  test.identical( dst.filePath, expectedDstFilePath );
  test.identical( dst.basePath, expectedDstBasePath );
  test.identical( src.prefixPath, null );
  test.identical( src.filePath, expectedDstFilePath );
  test.identical( src.basePath, expectedDstBasePath );

  /* - */

  test.case = 'full dst form, dst.prefixPath is array, dst.filePath has absolute path with empty string';
  var dst = provider.recordFilter();
  dst.basePath = '/dir';
  var src = provider.recordFilter();
  src.prefixPath = [ '/dir/d1/**', '/dir/d2/**' ];
  src.basePath = './d11';
  src.filePath = { '/dir/**b**' : '' }
  dst.pathsExtend( src );

  test.case = 'drop prefix';

  var expectedDstFilePath = { '/dir/**b**' : '' };
  var expectedDstBasePath = { '/dir/**b**' : '/dir/d1/d11' };

  test.identical( dst.prefixPath, null );
  test.identical( dst.filePath, expectedDstFilePath );
  test.identical( dst.basePath, expectedDstBasePath );
  test.identical( src.prefixPath, null );
  test.identical( src.filePath, expectedDstFilePath );
  test.identical( src.basePath, '/dir/d1/d11' );

  /* - */

  test.case = 'src.filePath and dst.filePath has nulls';
  var dst = provider.recordFilter();
  dst.prefixPath = 'commonDir/filter1';
  dst.basePath = './proto';
  dst.filePath = { 'f' : null, 'd' : null, 'ex' : false, 'f1' : null, 'd1' : '', 'ex1' : false, 'ex3' : null, 'ex4' : false };
  var src = provider.recordFilter();
  src.prefixPath = 'commonDir/filter2';
  src.basePath = './proto';
  src.filePath = { 'f' : null, 'd' : null, 'ex' : false, 'f2' : null, 'd2' : '', 'ex2' : false, 'ex3' : false, 'ex4' : null };
  dst.pathsExtend( src );

  var expectedDstFilePath =
  {
    'commonDir/filter1/f' : '',
    'commonDir/filter1/d' : '',
    'commonDir/filter1/ex' : false,
    'commonDir/filter1/f1' : '',
    'commonDir/filter1/d1' : '',
    'commonDir/filter1/ex1' : false,
    'commonDir/filter1/ex3' : '',
    'commonDir/filter1/ex4' : false,
    'commonDir/filter2/f' : '',
    'commonDir/filter2/d' : '',
    'commonDir/filter2/ex' : false,
    'commonDir/filter2/f2' : '',
    'commonDir/filter2/d2' : '',
    'commonDir/filter2/ex2' : false,
    'commonDir/filter2/ex3' : false,
    'commonDir/filter2/ex4' : ''
  };
  var expectedDstBasePath =
  {
    'commonDir/filter1/f' : 'commonDir/filter1/proto',
    'commonDir/filter1/d' : 'commonDir/filter1/proto',
    'commonDir/filter1/f1' : 'commonDir/filter1/proto',
    'commonDir/filter1/d1' : 'commonDir/filter1/proto',
    'commonDir/filter1/ex3' : 'commonDir/filter1/proto',
    'commonDir/filter2/f' : 'commonDir/filter2/proto',
    'commonDir/filter2/d' : 'commonDir/filter2/proto',
    'commonDir/filter2/f2' : 'commonDir/filter2/proto',
    'commonDir/filter2/d2' : 'commonDir/filter2/proto',
    'commonDir/filter2/ex4' : 'commonDir/filter2/proto'
  };
  var expectedSrcFilePath =
  {
    'commonDir/filter2/f' : '',
    'commonDir/filter2/d' : '',
    'commonDir/filter2/ex' : false,
    'commonDir/filter2/f2' : '',
    'commonDir/filter2/d2' : '',
    'commonDir/filter2/ex2' : false,
    'commonDir/filter2/ex3' : false,
    'commonDir/filter2/ex4' : ''
  };

  test.identical( dst.prefixPath, null );
  test.identical( dst.filePath, expectedDstFilePath );
  test.identical( dst.basePath, expectedDstBasePath );
  test.identical( src.prefixPath, null );
  test.identical( src.filePath, expectedSrcFilePath );
  test.identical( src.basePath, 'commonDir/filter2/proto' );

  /* - */

  test.open ( 'dst extends by many src filters' );

  var dst = provider.recordFilter();
  dst.prefixPath = '/commonDir';
  dst.filePath = { '*exclude*' : false };
  var src = provider.recordFilter();
  src.prefixPath = '/commonDir';
  src.filePath = { 'filter1/f' : 'out/dir' };
  dst.pathsExtend( src );

  test.identical( dst.prefixPath, null );
  test.identical( dst.basePath, null );
  test.identical( dst.filePath, { '/commonDir/*exclude*' : false, '/commonDir' : '', '/commonDir/filter1/f' : 'out/dir' } );
  test.identical( src.prefixPath, null );
  test.identical( src.basePath, null );
  test.identical( src.filePath, { '/commonDir/filter1/f' : 'out/dir' } );

  var src = provider.recordFilter();
  src.prefixPath = '/commonDir';
  src.filePath = { 'filter1/f' : 'out/dir' };
  dst.pathsExtend( src );

  test.identical( dst.prefixPath, null );
  test.identical( dst.basePath, null );
  test.identical( dst.filePath, { '/commonDir/*exclude*' : false, '/commonDir' : '', '/commonDir/filter1/f' : 'out/dir' } );
  test.identical( src.prefixPath, null );
  test.identical( src.basePath, null );
  test.identical( src.filePath, { '/commonDir/filter1/f' : 'out/dir' } );

  var src = provider.recordFilter();
  src.prefixPath = '/commonDir/filter1';
  src.filePath = { 'f' : 'out/dir' };
  dst.pathsExtend( src );

  test.identical( dst.prefixPath, null );
  test.identical( dst.basePath, null );
  test.identical( dst.filePath, { '/commonDir/*exclude*' : false, '/commonDir' : '', '/commonDir/filter1/f' : 'out/dir' } );
  test.identical( src.prefixPath, null );
  test.identical( src.basePath, null );
  test.identical( src.filePath, { '/commonDir/filter1/f' : 'out/dir' } );

  var src = provider.recordFilter();
  src.filePath = { '/commonDir/filter1/f' : '/commonDir/out/dir' };
  dst.pathsExtend( src );

  var expectedFilePath =
  {
    '/commonDir/*exclude*' : false,
    '/commonDir' : '',
    '/commonDir/filter1/f' : '/commonDir/out/dir',
  };

  test.identical( dst.prefixPath, null );
  test.identical( dst.basePath, null );
  test.identical( dst.filePath, expectedFilePath );
  test.identical( src.prefixPath, null );
  test.identical( src.basePath, null );
  test.identical( src.filePath, { '/commonDir/filter1/f' : '/commonDir/out/dir' } );

  test.close ( 'dst extends by many src filters' );

  /* - */

  test.case = 'dst.filePath is dot, extends by src.filePath ( map ), src.basePath ( string )';
  var dst = provider.recordFilter();
  dst.filePath = { '.' : null };
  var src = provider.recordFilter();
  src.filePath = { '/a/b1' : null, '/a/b2' : null };
  src.basePath = '/a';
  dst.pathsExtend( src );

  test.identical( dst.prefixPath, null );
  test.identical( dst.basePath, '/a' );
  test.identical( dst.filePath, { '/a/b1' : '', '/a/b2' : '', '.' : '' } );
  test.identical( src.prefixPath, null );
  test.identical( src.basePath, '/a' );
  test.identical( src.filePath, { '/a/b1' : '', '/a/b2' : '', } );

  /* - */

  test.case = 'dst.basePath is string, extends by full src form';
  var dst = provider.recordFilter();
  dst.basePath = '/base';
  var src = provider.recordFilter();
  src.filePath = { './**' : '' }
  src.basePath = '/base/src2';
  src.prefixPath = '/base/src2';
  dst.pathsExtend( src );
  
  test.identical( dst.prefixPath, null );
  test.identical( dst.basePath, { '/base/src2/**' : '/base/src2' } );
  test.identical( dst.filePath, { '/base/src2/**' : '' } );
  test.identical( src.prefixPath, null );
  test.identical( src.basePath, '/base/src2' );
  test.identical( src.filePath, { '/base/src2/**' : '' } );
}

//

function pathsExtendJoining( test )
{
  let context = this;
  let provider = new _.FileProvider.Extract();
  let path = provider.path;

  /* */

  test.case = 'src rel string, dst rel string';

  var f1 = provider.recordFilter();
  f1.filePath = 'a';

  var f2 = provider.recordFilter();
  f2.filePath = 'b';

  var f3 = provider.recordFilter();
  f3.pathsExtendJoining( f1 ).pathsExtendJoining( f2 );

  test.identical( f3.prefixPath, null );
  test.identical( f3.filePath, 'a/b' );
  test.identical( f3.basePath, null );

  /* */

  test.case = 'src abs string, dst abs string';

  var f1 = provider.recordFilter();
  f1.filePath = '/a';

  var f2 = provider.recordFilter();
  f2.filePath = '/b';

  var f3 = provider.recordFilter();
  f3.pathsExtendJoining( f1 ).pathsExtendJoining( f2 );

  test.identical( f3.prefixPath, null );
  test.identical( f3.filePath, '/b' );
  test.identical( f3.basePath, null );

  /* */

  test.case = 'src string, dst map';

  var f1 = provider.recordFilter();
  f1.filePath = { 'a' : '' };

  var f2 = provider.recordFilter();
  f2.filePath = 'b';

  var f3 = provider.recordFilter();
  f3.pathsExtendJoining( f1 ).pathsExtendJoining( f2 );

  test.identical( f3.prefixPath, null );
  test.identical( f3.filePath, 'a/b' );
  test.identical( f3.basePath, null );

  /* */

  test.case = 'src map, dst string';

  var f1 = provider.recordFilter();
  f1.filePath = '/a';

  var f2 = provider.recordFilter();
  f2.filePath = { '/b' : '' };

  var f3 = provider.recordFilter();
  f3.pathsExtendJoining( f1 ).pathsExtendJoining( f2 );

  test.identical( f3.prefixPath, null );
  test.identical( f3.filePath, '/b' );
  test.identical( f3.basePath, null );

  /* */

  test.case = 'src map, dst map with bools';

  var f1 = provider.recordFilter();
  f1.filePath = { 'node_modules' : 0, 'package.json' : 0, '*.js' : 1 };

  var f2 = provider.recordFilter();
  f2.filePath = { 'dir' : '' }

  var f3 = provider.recordFilter();
  f3.pathsExtendJoining( f1 ).pathsExtendJoining( f2 );

  test.identical( f3.prefixPath, null );
  test.identical( f3.filePath, { 'dir' : '', 'node_modules' : false, 'package.json' : false, '*.js' : true } );
  test.identical( f3.basePath, null );

  /* */

  test.case = 'src map with bools, dst map';

  var f1 = provider.recordFilter();
  f1.filePath = { 'dir' : '' };

  var f2 = provider.recordFilter();
  f2.filePath = { 'node_modules' : 0, 'package.json' : 0, '*.js' : 1 }

  var f3 = provider.recordFilter();
  f3.pathsExtendJoining( f1 ).pathsExtendJoining( f2 );

  test.identical( f3.prefixPath, null );
  test.identical( f3.filePath, { 'dir' : '', 'node_modules' : false, 'package.json' : false, '*.js' : true } );
  test.identical( f3.basePath, null );

  /* */

  test.case = 'bools only';

  var f1 = provider.recordFilter();
  f1.prefixPath = '/commonDir/filter1'
  f1.basePath = './proto';
  f1.filePath = { 'f' : true, 'd' : true, 'ex' : false, 'f1' : true, 'd1' : true, 'ex1' : false, 'ex3' : true, 'ex4' : false }

  var f2 = provider.recordFilter();
  f2.prefixPath = '/commonDir/filter2'
  f2.basePath = './proto';
  f2.filePath = { 'f' : true, 'd' : true, 'ex' : false, 'f2' : true, 'd2' : true, 'ex2' : false, 'ex3' : false, 'ex4' : true }

  var f3 = provider.recordFilter();
  f3.pathsExtendJoining( f1 ).pathsExtendJoining( f2 );

  var expectedFilePath =
  {
    '/commonDir/filter1/f' : true,
    '/commonDir/filter1/d' : true,
    '/commonDir/filter1/ex' : false,
    '/commonDir/filter1/f1' : true,
    '/commonDir/filter1/d1' : true,
    '/commonDir/filter1/ex1' : false,
    '/commonDir/filter1/ex3' : true,
    '/commonDir/filter1/ex4' : false,
    '/commonDir/filter2/f' : true,
    '/commonDir/filter2/d' : true,
    '/commonDir/filter2/ex' : false,
    '/commonDir/filter2/f2' : true,
    '/commonDir/filter2/d2' : true,
    '/commonDir/filter2/ex2' : false,
    '/commonDir/filter2/ex3' : false,
    '/commonDir/filter2/ex4' : true,
    '/commonDir/filter2' : ''
  }

  var expectedBasePath =
  {
    // '/commonDir/filter1' : '/commonDir/filter1/proto',
    '/commonDir/filter2' : '/commonDir/filter2/proto'
  }

  test.identical( f3.prefixPath, null );
  test.identical( f3.filePath, expectedFilePath );
  test.identical( f3.basePath, expectedBasePath );

  /* */

  test.case = 'file path only bools, complex';

  var expectedFilePath =
  {
    '/dir/doubledir/d1/**' : '',
    '/dir/**' : '',
    '/dir/doubledir/d1/**/**b**' : false,
    '/dir/**/**b**' : false,
  }

  var expectedBasePath =
  {
    '/dir/doubledir/d1/**' : '/dir/doubledir/d1/base',
    '/dir/**' : '/dir/base',
  }

  var f1 = provider.recordFilter();
  f1.basePath = '/dir';

  var f2 = provider.recordFilter();
  f2.prefixPath = [ '/dir/doubledir/d1/**', '/dir/**' ];
  f2.basePath = './base';
  f2.filePath = { '.' : true, '**b**' : false }

  var f3 = provider.recordFilter();
  f3.pathsExtendJoining( f1 ).pathsExtendJoining( f2 );

  test.identical( f3.prefixPath, null );
  test.identical( f3.filePath, expectedFilePath );
  test.identical( f3.basePath, expectedBasePath );

  /* */

  test.case = 'multiply false';

  var expectedFilePath =
  {
    '/dir/**b**' : false,
    '/dir/d1/**' : '',
    '/dir/d2/**' : '',
  }

  var expectedBasePath =
  {
    '/dir/d1/**' : '/dir/d1/d11',
    '/dir/d2/**' : '/dir/d2/d11',
  }

  var f1 = provider.recordFilter();
  f1.basePath = '/dir';

  var f2 = provider.recordFilter();
  f2.prefixPath = [ '/dir/d1/**', '/dir/d2/**' ];
  f2.basePath = './d11';
  f2.filePath = { '/dir/**b**' : false }

  var f3 = provider.recordFilter();
  f3.pathsExtendJoining( f1 ).pathsExtendJoining( f2 );

  test.identical( f3.prefixPath, null );
  test.identical( f3.filePath, expectedFilePath );
  test.identical( f3.basePath, expectedBasePath );

  /* */

  test.case = 'drop prefix';

  var expectedFilePath = '/dir/**b**';
  var expectedBasePath = { '/dir/**b**' : '/dir/d1/d11' };

  var f1 = provider.recordFilter();
  f1.basePath = '/dir';

  var f2 = provider.recordFilter();
  f2.prefixPath = [ '/dir/d1/**', '/dir/d2/**' ];
  f2.basePath = './d11';
  f2.filePath = { '/dir/**b**' : '' }

  var f3 = provider.recordFilter();
  f3.pathsExtendJoining( f1 ).pathsExtendJoining( f2 );

  test.identical( f3.prefixPath, null );
  test.identical( f3.filePath, expectedFilePath );
  test.identical( f3.basePath, expectedBasePath );

  /* */

  test.case = 'nulls';

  var f1 = provider.recordFilter();
  f1.prefixPath = 'commonDir/filter1'
  f1.basePath = './proto';
  f1.filePath = { 'f' : null, 'd' : null, 'ex' : false, 'f1' : null, 'd1' : '', 'ex1' : false, 'ex3' : null, 'ex4' : false }

  var f2 = provider.recordFilter();
  f2.prefixPath = 'commonDir/filter2'
  f2.basePath = './proto';
  f2.filePath = { 'f' : null, 'd' : null, 'ex' : false, 'f2' : null, 'd2' : '', 'ex2' : false, 'ex3' : false, 'ex4' : null }

  var f3 = provider.recordFilter();
  f3.pathsExtendJoining( f1 ).pathsExtendJoining( f2 );

  var expectedFilePath =
  {
    'commonDir/filter1/ex' : false,
    'commonDir/filter1/ex1' : false,
    'commonDir/filter1/ex4' : false,
    'commonDir/filter2/ex' : false,
    'commonDir/filter2/ex2' : false,
    'commonDir/filter2/ex3' : false,

    'commonDir/filter1/f/commonDir/filter2/f' : '',
    'commonDir/filter1/f/commonDir/filter2/d' : '',
    'commonDir/filter1/f/commonDir/filter2/f2' : '',
    'commonDir/filter1/f/commonDir/filter2/d2' : '',
    'commonDir/filter1/f/commonDir/filter2/ex4' : '',
    'commonDir/filter1/d/commonDir/filter2/f' : '',
    'commonDir/filter1/d/commonDir/filter2/d' : '',
    'commonDir/filter1/d/commonDir/filter2/f2' : '',
    'commonDir/filter1/d/commonDir/filter2/d2' : '',
    'commonDir/filter1/d/commonDir/filter2/ex4' : '',
    'commonDir/filter1/f1/commonDir/filter2/f' : '',
    'commonDir/filter1/f1/commonDir/filter2/d' : '',
    'commonDir/filter1/f1/commonDir/filter2/f2' : '',
    'commonDir/filter1/f1/commonDir/filter2/d2' : '',
    'commonDir/filter1/f1/commonDir/filter2/ex4' : '',
    'commonDir/filter1/d1/commonDir/filter2/f' : '',
    'commonDir/filter1/d1/commonDir/filter2/d' : '',
    'commonDir/filter1/d1/commonDir/filter2/f2' : '',
    'commonDir/filter1/d1/commonDir/filter2/d2' : '',
    'commonDir/filter1/d1/commonDir/filter2/ex4' : '',
    'commonDir/filter1/ex3/commonDir/filter2/f' : '',
    'commonDir/filter1/ex3/commonDir/filter2/d' : '',
    'commonDir/filter1/ex3/commonDir/filter2/f2' : '',
    'commonDir/filter1/ex3/commonDir/filter2/d2' : '',
    'commonDir/filter1/ex3/commonDir/filter2/ex4' : '',
  }
  var expectedBasePath =
  {
    'commonDir/filter1/f/commonDir/filter2/f' : 'commonDir/filter1/proto/commonDir/filter2/proto',
    'commonDir/filter1/f/commonDir/filter2/d' : 'commonDir/filter1/proto/commonDir/filter2/proto',
    'commonDir/filter1/f/commonDir/filter2/f2' : 'commonDir/filter1/proto/commonDir/filter2/proto',
    'commonDir/filter1/f/commonDir/filter2/d2' : 'commonDir/filter1/proto/commonDir/filter2/proto',
    'commonDir/filter1/f/commonDir/filter2/ex4' : 'commonDir/filter1/proto/commonDir/filter2/proto',
    'commonDir/filter1/d/commonDir/filter2/f' : 'commonDir/filter1/proto/commonDir/filter2/proto',
    'commonDir/filter1/d/commonDir/filter2/d' : 'commonDir/filter1/proto/commonDir/filter2/proto',
    'commonDir/filter1/d/commonDir/filter2/f2' : 'commonDir/filter1/proto/commonDir/filter2/proto',
    'commonDir/filter1/d/commonDir/filter2/d2' : 'commonDir/filter1/proto/commonDir/filter2/proto',
    'commonDir/filter1/d/commonDir/filter2/ex4' : 'commonDir/filter1/proto/commonDir/filter2/proto',
    'commonDir/filter1/f1/commonDir/filter2/f' : 'commonDir/filter1/proto/commonDir/filter2/proto',
    'commonDir/filter1/f1/commonDir/filter2/d' : 'commonDir/filter1/proto/commonDir/filter2/proto',
    'commonDir/filter1/f1/commonDir/filter2/f2' : 'commonDir/filter1/proto/commonDir/filter2/proto',
    'commonDir/filter1/f1/commonDir/filter2/d2' : 'commonDir/filter1/proto/commonDir/filter2/proto',
    'commonDir/filter1/f1/commonDir/filter2/ex4' : 'commonDir/filter1/proto/commonDir/filter2/proto',
    'commonDir/filter1/d1/commonDir/filter2/f' : 'commonDir/filter1/proto/commonDir/filter2/proto',
    'commonDir/filter1/d1/commonDir/filter2/d' : 'commonDir/filter1/proto/commonDir/filter2/proto',
    'commonDir/filter1/d1/commonDir/filter2/f2' : 'commonDir/filter1/proto/commonDir/filter2/proto',
    'commonDir/filter1/d1/commonDir/filter2/d2' : 'commonDir/filter1/proto/commonDir/filter2/proto',
    'commonDir/filter1/d1/commonDir/filter2/ex4' : 'commonDir/filter1/proto/commonDir/filter2/proto',
    'commonDir/filter1/ex3/commonDir/filter2/f' : 'commonDir/filter1/proto/commonDir/filter2/proto',
    'commonDir/filter1/ex3/commonDir/filter2/d' : 'commonDir/filter1/proto/commonDir/filter2/proto',
    'commonDir/filter1/ex3/commonDir/filter2/f2' : 'commonDir/filter1/proto/commonDir/filter2/proto',
    'commonDir/filter1/ex3/commonDir/filter2/d2' : 'commonDir/filter1/proto/commonDir/filter2/proto',
    'commonDir/filter1/ex3/commonDir/filter2/ex4' : 'commonDir/filter1/proto/commonDir/filter2/proto'
  }
  test.identical( f3.prefixPath, null );
  test.identical( f3.filePath, expectedFilePath );
  test.identical( f3.basePath, expectedBasePath );

  /* */

  test.case = 'multiple 1';

  var f1 = provider.recordFilter();
  f1.prefixPath = '/commonDir';
  f1.filePath = { '*exclude*' : 0 }

  var f2 = provider.recordFilter();
  f2.prefixPath = '/commonDir';
  f2.filePath = { 'filter1/f' : 'out/dir' }
  f1.pathsExtendJoining( f2 );
  test.identical( f1.prefixPath, null );
  test.identical( f1.basePath, null );
  test.identical( f1.filePath, { '/commonDir/*exclude*' : false, '/commonDir/filter1/f' : 'out/dir' } );
  test.identical( f2.prefixPath, null );
  test.identical( f2.basePath, null );
  test.identical( f2.filePath, { '/commonDir/filter1/f' : 'out/dir' } );

  test.case = 'multiple 2';

  var f1 = provider.recordFilter();
  f1.prefixPath = null;
  f1.filePath = { '/commonDir/*exclude*' : false, '/commonDir/filter1/f' : 'out/dir1' }

  var f3 = provider.recordFilter();
  f3.prefixPath = '/commonDir';
  f3.filePath = { 'filter1/f' : 'out/dir2' }
  f1.pathsExtendJoining( f3 );
  test.identical( f1.prefixPath, null );
  test.identical( f1.basePath, null );
  test.identical( f1.filePath, { '/commonDir/*exclude*' : false, '/commonDir/filter1/f' : 'out/dir1/out/dir2' } );
  test.identical( f3.prefixPath, null );
  test.identical( f3.basePath, null );
  test.identical( f3.filePath, { '/commonDir/filter1/f' : 'out/dir2' } );

  var f4 = provider.recordFilter();
  f4.prefixPath = '/commonDir/filter1'
  f4.filePath = { 'f' : 'out/dir4' }
  f1.pathsExtendJoining( f4 );
  test.identical( f1.prefixPath, null );
  test.identical( f1.basePath, null );
  test.identical( f1.filePath, { '/commonDir/filter1/f' : 'out/dir1/out/dir2/out/dir4', '/commonDir/*exclude*' : false } );
  test.identical( f4.prefixPath, null );
  test.identical( f4.basePath, null );
  test.identical( f4.filePath, { '/commonDir/filter1/f' : 'out/dir4' } );

  var expectedFilePath = { '/commonDir/filter1/f' : '/commonDir/out/dir', '/commonDir/*exclude*' : false }
  var f5 = provider.recordFilter();
  f5.filePath = { '/commonDir/filter1/f' : '/commonDir/out/dir' }
  f1.pathsExtendJoining( f5 );
  test.identical( f1.prefixPath, null );
  test.identical( f1.basePath, null );
  test.identical( f1.filePath, expectedFilePath );
  test.identical( f5.prefixPath, null );
  test.identical( f5.basePath, null );
  test.identical( f5.filePath, { '/commonDir/filter1/f' : '/commonDir/out/dir' } );

  /*  */

  test.case = 'extend dot';

  var f1 = provider.recordFilter();
  f1.filePath = { '.' : null }

  var f2 = provider.recordFilter();
  f2.filePath =
  {
    '/a/b1' : null,
    '/a/b2' : null,
  }
  f2.basePath = '/a';

  f1.pathsExtendJoining( f2 );
  test.identical( f1.prefixPath, null );
  // test.identical( f1.basePath, { '/a/b1' : '/a', '/a/b2' : '/a' } );
  test.identical( f1.basePath, '/a' );
  test.identical( f1.filePath, [ '/a/b1', '/a/b2' ] );
  test.identical( f2.prefixPath, null );
  test.identical( f2.basePath, '/a' );
  test.identical( f2.filePath, { '/a/b1' : null, '/a/b2' : null, } );

  /* */

  test.case = 'extend dot';

  var f1 = provider.recordFilter();
  f1.basePath = '/base';

  var f2 = provider.recordFilter();
  f2.filePath = { './**' : '' }
  f2.basePath = '/base/src2';
  f2.prefixPath = '/base/src2';

  f1.pathsExtendJoining( f2 );
  test.identical( f1.prefixPath, null );
  test.identical( f1.basePath, { '/base/src2/**' : '/base/src2' } );
  test.identical( f1.filePath, '/base/src2/**' );
  test.identical( f2.prefixPath, null );
  test.identical( f2.basePath, '/base/src2' );
  test.identical( f2.filePath, { '/base/src2/**' : '' } );

  /* */

  test.case = 'dst file path is array, dst base path is map, src base path is null';

  var dst = provider.recordFilter();
  dst.filePath = [ '/dir/d1/**', '/dir/d2/**' ]
  dst.basePath =
  {
    '/dir/d1/**' : '/dir',
    '/dir/d2/**' : '/dir',
  }

  var src = provider.recordFilter();
  src.basePath = null;

  dst.pathsExtendJoining( src );

  test.identical( dst.prefixPath, null );
  test.identical( dst.filePath, [ '/dir/d1/**', '/dir/d2/**' ] );
  test.identical( dst.basePath, { '/dir/d1/**' : '/dir', '/dir/d2/**' : '/dir', } );

  test.identical( src.prefixPath, null );
  test.identical( src.filePath, null );
  test.identical( src.basePath, null );

  test.case = 'dst file path is array, dst base path is map, src base path is empty string';

  var dst = provider.recordFilter();
  dst.filePath = [ '/dir/d1/**', '/dir/d2/**' ]
  dst.basePath =
  {
    '/dir/d1/**' : '/dir',
    '/dir/d2/**' : '/dir',
  }

  var src = provider.recordFilter();
  src.basePath = ''

  dst.pathsExtendJoining( src );

  test.identical( dst.prefixPath, null );
  test.identical( dst.filePath, [ '/dir/d1/**', '/dir/d2/**' ] );
  test.identical( dst.basePath, null );

  test.identical( src.prefixPath, null );
  test.identical( src.filePath, null );
  test.identical( src.basePath, '' );

  /* */

  test.case = 'dst file path is array, dst base path is map, src base path is null';

  var dst = provider.recordFilter();
  dst.filePath = [ '/dir/d1/**', '/dir/d2/**' ]
  dst.basePath =
  {
    '/dir/d1/**' : '/dir',
    '/dir/d2/**' : '/dir',
  }

  var src = provider.recordFilter();
  src.basePath = null;

  dst.pathsExtendJoining( src );

  test.identical( dst.prefixPath, null );
  test.identical( dst.filePath, [ '/dir/d1/**', '/dir/d2/**' ] );
  test.identical( dst.basePath, { '/dir/d1/**' : '/dir', '/dir/d2/**' : '/dir', } );

  test.identical( src.prefixPath, null );
  test.identical( src.filePath, null );
  test.identical( src.basePath, null );

  test.case = 'dst file path is map, dst base path is rel str, src prefix is abs str';

  var dst = provider.recordFilter();
  dst.filePath = { '/dir/d1/**' : '', '/dir/d2/**' : '' }
  dst.basePath = './dir/d1/d11';

  var src = provider.recordFilter();
  src.prefixPath = '/';

  dst.pathsExtendJoining( src );

  test.identical( dst.prefixPath, '/' );
  test.identical( dst.filePath, [ '/dir/d1/**', '/dir/d2/**' ] );
  test.identical( dst.basePath, './dir/d1/d11' );
  // test.identical( dst.basePath, { '/dir/d1/**' : './dir/d1/d11', '/dir/d2/**' : './dir/d1/d11' } );

  test.identical( src.prefixPath, '/' );
  test.identical( src.filePath, null );
  test.identical( src.basePath, null );

  /* */

  test.case = 'dst prefix is abs str, src file path is map, src base path is rel str';

  var dst = provider.recordFilter();
  dst.prefixPath = '/';

  var src = provider.recordFilter();
  src.filePath = { '/dir/d1/**' : '', '/dir/d2/**' : '' }
  src.basePath = './dir/d1/d11';

  dst.pathsExtendJoining( src );

  test.identical( dst.prefixPath, '/' );
  test.identical( dst.filePath, [ '/dir/d1/**', '/dir/d2/**' ] );
  test.identical( dst.basePath, './dir/d1/d11' );

  test.identical( src.prefixPath, null );
  test.identical( src.filePath, { '/dir/d1/**' : '', '/dir/d2/**' : '' } );
  test.identical( src.basePath, './dir/d1/d11' );

  debugger; return; xxx
}

//

function pathsInherit( test )
{
  let context = this;
  let provider = new _.FileProvider.Extract();
  let path = provider.path;

  /* */

  test.case = 'dst base is string, src base is string';

  var f1 = provider.recordFilter();
  f1.basePath = 'dst/base';

  var f2 = provider.recordFilter();
  f2.basePath = 'src/base';

  var f3 = provider.recordFilter();
  f3.pathsInherit( f1 ).pathsInherit( f2 );

  test.identical( f3.prefixPath, null );
  test.identical( f3.filePath, null );
  test.identical( f3.basePath, 'src/base/dst/base' );
  // test.identical( f3.basePath, 'src/base' );

  /* */

  test.case = 'dst base is map, src base is string';

  var dst = provider.recordFilter();
  dst.filePath =
  {
    '/dir/proto/File.js' : '/dst1/out',
    '/dir/proto/File.s' : '/dst1/out',
  }

  var src = provider.recordFilter();
  src.basePath = { '/dir/src1' : '/dst2' }
  src.basePath = { '.' : 'dst/base' };

  dst.pathsInherit( src );

  test.identical( dst.prefixPath, null );
  test.identical( dst.filePath, { '/dir/proto/File.js' : '/dst1/out', '/dir/proto/File.s' : '/dst1/out', } );
  test.identical( dst.basePath, { '.' : 'dst/base' } );

  /* */

  test.case = 'dst base is map, src base is string';

  var f1 = provider.recordFilter();
  f1.basePath = { '.' : 'dst/base' };

  var f2 = provider.recordFilter();
  f2.basePath = 'src/base';

  var f3 = provider.recordFilter();
  f3.pathsInherit( f1 ).pathsInherit( f2 );

  test.identical( f3.prefixPath, null );
  test.identical( f3.filePath, null );
  // test.identical( f3.basePath, 'src/base' );
  test.identical( f3.basePath, { '.' : 'dst/base' } );

  /* */

  test.case = 'dst base is string, src base is map';

  var f1 = provider.recordFilter();
  f1.basePath = 'dst/base';

  var f2 = provider.recordFilter();
  f2.basePath = { '.' : 'src/base' };

  var f3 = provider.recordFilter();
  f3.pathsInherit( f1 ).pathsInherit( f2 );

  test.identical( f3.prefixPath, null );
  test.identical( f3.filePath, null );
  test.identical( f3.basePath, 'dst/base' );
  // test.identical( f3.basePath, { '.' : 'src/base' } );

  /* */

  test.case = 'dst base is map, src base is map, collising';

  var f1 = provider.recordFilter();
  f1.basePath = { '.' : 'dst/base' };

  var f2 = provider.recordFilter();
  f2.basePath = { '.' : 'src/base' };

  var f3 = provider.recordFilter();
  f3.pathsInherit( f1 ).pathsInherit( f2 );

  test.identical( f3.prefixPath, null );
  test.identical( f3.filePath, null );
  test.identical( f3.basePath, { '.' : 'src/base/dst/base' } );

  /* */

  test.case = 'dst base is map, src base is map, no collising';

  var f1 = provider.recordFilter();
  f1.basePath = { 'dst' : 'dst/base' };

  var f2 = provider.recordFilter();
  f2.basePath = { 'src' : 'src/base' };

  var f3 = provider.recordFilter();
  f3.pathsInherit( f1 ).pathsInherit( f2 );

  test.identical( f3.prefixPath, null );
  test.identical( f3.filePath, null );
  test.identical( f3.basePath, { 'dst' : 'dst/base' } );

  /* */

  test.case = 'bools only';

  var f1 = provider.recordFilter();
  f1.prefixPath = '/commonDir/filter1';
  f1.basePath = './proto';
  f1.filePath = { 'f' : true, 'd' : true, 'ex' : false, 'f1' : true, 'd1' : true, 'ex1' : false, 'ex3' : true, 'ex4' : false }

  var f3 = provider.recordFilter();
  f3.pathsInherit( f1 )

  // var expectedFilePath =
  // {
  //   'f' : true,
  //   'd' : true,
  //   'ex' : false,
  //   'f1' : true,
  //   'd1' : true,
  //   'ex1' : false,
  //   'ex3' : true,
  //   'ex4' : false,
  // }
  //
  // var expectedBasePath = './proto';
  //
  // test.identical( f3.prefixPath, '/commonDir/filter1' );
  // test.identical( f3.filePath, expectedFilePath );
  // test.identical( f3.basePath, expectedBasePath );

  var expectedFilePath =
  {
    '/commonDir/filter1/f' : true,
    '/commonDir/filter1/d' : true,
    '/commonDir/filter1/ex' : false,
    '/commonDir/filter1/f1' : true,
    '/commonDir/filter1/d1' : true,
    '/commonDir/filter1/ex1' : false,
    '/commonDir/filter1/ex3' : true,
    '/commonDir/filter1/ex4' : false,
    '/commonDir/filter1' : ''
  }

  var expectedBasePath = '/commonDir/filter1/proto';

  test.identical( f3.prefixPath, null );
  test.identical( f3.filePath, expectedFilePath );
  test.identical( f3.basePath, expectedBasePath );

  /* */

  // var expectedFilePath =
  // {
  //   'f' : true,
  //   'd' : true,
  //   'ex' : false,
  //   'f1' : true,
  //   'd1' : true,
  //   'ex1' : false,
  //   'ex3' : false,
  //   'ex4' : true,
  //   'f2' : true,
  //   'd2' : true,
  //   'ex2' : false
  // }
  //
  // var expectedBasePath =
  // {
  //   'f' : '/commonDir/filter1/proto',
  //   'd' : '/commonDir/filter1/proto',
  //   'f1' : '/commonDir/filter1/proto',
  //   'd1' : '/commonDir/filter1/proto',
  //   'f2' : '/commonDir/filter2/proto',
  //   'd2' : '/commonDir/filter2/proto',
  //   'ex4' : '/commonDir/filter2/proto'
  // }

  test.case = 'file path map of src has non-bool';

  var src = provider.recordFilter();
  src.prefixPath = '/commonDir/src';
  src.basePath = '/commonDir/src/proto';
  src.filePath =
  {
    '/commonDir/src/f' : true,
    '/commonDir/src/d' : true,
    '/commonDir/src/ex' : false,
    '/commonDir/src/f1' : true,
    '/commonDir/src/d1' : true,
    '/commonDir/src/ex1' : false,
    '/commonDir/src/ex3' : true,
    '/commonDir/src/ex4' : false,
    '/commonDir/src' : ''
  }

  var dst = provider.recordFilter();
  dst.prefixPath = '/commonDir/dst';
  dst.basePath = './proto';
  dst.filePath = { 'f' : true, 'd' : true, 'ex' : false, 'f2' : true, 'd2' : true, 'ex2' : false, 'ex3' : false, 'ex4' : true }

  dst.pathsInherit( src );

  var expectedFilePath =
  {
    '/commonDir/src/f' : true,
    '/commonDir/src/d' : true,
    '/commonDir/src/ex' : false,
    '/commonDir/src/f1' : true,
    '/commonDir/src/d1' : true,
    '/commonDir/src/ex1' : false,
    '/commonDir/src/ex3' : true,
    '/commonDir/src/ex4' : false,
    '/commonDir/dst' : '',
    '/commonDir/dst/f' : true,
    '/commonDir/dst/d' : true,
    '/commonDir/dst/ex' : false,
    '/commonDir/dst/f2' : true,
    '/commonDir/dst/d2' : true,
    '/commonDir/dst/ex2' : false,
    '/commonDir/dst/ex3' : false,
    '/commonDir/dst/ex4' : true
  }

  var expectedBasePath = { '/commonDir/dst' : '/commonDir/dst/proto' }

  test.identical( dst.prefixPath, null );
  test.identical( dst.filePath, expectedFilePath );
  test.identical( dst.basePath, expectedBasePath );

  var expectedFilePath =
  {
    '/commonDir/src/f' : true,
    '/commonDir/src/d' : true,
    '/commonDir/src/ex' : false,
    '/commonDir/src/f1' : true,
    '/commonDir/src/d1' : true,
    '/commonDir/src/ex1' : false,
    '/commonDir/src/ex3' : true,
    '/commonDir/src/ex4' : false,
    '/commonDir/src' : ''
  }

  var expectedBasePath = '/commonDir/src/proto';

  test.identical( src.prefixPath, null );
  test.identical( src.filePath, expectedFilePath );
  test.identical( src.basePath, expectedBasePath );

  /* */

  test.case = 'nulls';

  var f1 = provider.recordFilter();
  f1.prefixPath = 'commonDir/filter1'
  f1.basePath = './proto';
  f1.filePath = { 'f' : null, 'd' : null, 'ex' : false, 'f1' : null, 'd1' : '', 'ex1' : false, 'ex3' : null, 'ex4' : false }

  var f2 = provider.recordFilter();
  f2.prefixPath = 'commonDir/filter2'
  f2.basePath = './proto';
  f2.filePath = { 'f' : null, 'd' : null, 'ex' : false, 'f2' : null, 'd2' : '', 'ex2' : false, 'ex3' : false, 'ex4' : null }

  var f3 = provider.recordFilter();
  f3.pathsInherit( f1 ).pathsInherit( f2 );

  // var expectedFilePath =
  // {
  //   '/commonDir/filter1/f' : 'commonDir/filter1',
  //   'commonDir/filter1/d' : 'commonDir/filter1',
  //   'ex' : false,
  //   'commonDir/filter1/f1' : 'commonDir/filter1',
  //   'commonDir/filter1/d1' : 'commonDir/filter1',
  //   'ex1' : false,
  //   'commonDir/filter1/ex3' : 'commonDir/filter1',
  //   'ex4' : false,
  //   'ex2' : false,
  //   'ex3' : false,
  // }
  // var expectedBasePath =
  // {
  //   'commonDir/filter1/f' : 'commonDir/filter1/proto',
  //   'commonDir/filter1/d' : 'commonDir/filter1/proto',
  //   'commonDir/filter1/f1' : 'commonDir/filter1/proto',
  //   'commonDir/filter1/d1' : 'commonDir/filter1/proto',
  //   'commonDir/filter1/ex3' : 'commonDir/filter1/proto',
  // }
  //
  // var expectedFilePath =
  // {
  //   'commonDir/filter1/f' : '',
  //   'commonDir/filter1/d' : '',
  //   'commonDir/filter1/ex' : false,
  //   'commonDir/filter1/f1' : '',
  //   'commonDir/filter1/d1' : '',
  //   'commonDir/filter1/ex1' : false,
  //   'commonDir/filter1/ex3' : '',
  //   'commonDir/filter1/ex4' : false,
  //   'commonDir/filter2/ex' : false,
  //   'commonDir/filter2/ex2' : false,
  //   'commonDir/filter2/ex3' : false
  // }
  // var expectedBasePath =
  // {
  //   'commonDir/filter1/f' : 'commonDir/filter1/proto',
  //   'commonDir/filter1/d' : 'commonDir/filter1/proto',
  //   'commonDir/filter1/f1' : 'commonDir/filter1/proto',
  //   'commonDir/filter1/d1' : 'commonDir/filter1/proto',
  //   'commonDir/filter1/ex3' : 'commonDir/filter1/proto',
  // }

  var expectedFilePath =
  {
    'commonDir/filter2/f/commonDir/filter1/f' : '',
    'commonDir/filter2/d/commonDir/filter1/f' : '',
    'commonDir/filter2/f2/commonDir/filter1/f' : '',
    'commonDir/filter2/d2/commonDir/filter1/f' : '',
    'commonDir/filter2/ex4/commonDir/filter1/f' : '',
    'commonDir/filter2/f/commonDir/filter1/d' : '',
    'commonDir/filter2/d/commonDir/filter1/d' : '',
    'commonDir/filter2/f2/commonDir/filter1/d' : '',
    'commonDir/filter2/d2/commonDir/filter1/d' : '',
    'commonDir/filter2/ex4/commonDir/filter1/d' : '',
    'commonDir/filter2/f/commonDir/filter1/f1' : '',
    'commonDir/filter2/d/commonDir/filter1/f1' : '',
    'commonDir/filter2/f2/commonDir/filter1/f1' : '',
    'commonDir/filter2/d2/commonDir/filter1/f1' : '',
    'commonDir/filter2/ex4/commonDir/filter1/f1' : '',
    'commonDir/filter2/f/commonDir/filter1/d1' : '',
    'commonDir/filter2/d/commonDir/filter1/d1' : '',
    'commonDir/filter2/f2/commonDir/filter1/d1' : '',
    'commonDir/filter2/d2/commonDir/filter1/d1' : '',
    'commonDir/filter2/ex4/commonDir/filter1/d1' : '',
    'commonDir/filter2/f/commonDir/filter1/ex3' : '',
    'commonDir/filter2/d/commonDir/filter1/ex3' : '',
    'commonDir/filter2/f2/commonDir/filter1/ex3' : '',
    'commonDir/filter2/d2/commonDir/filter1/ex3' : '',
    'commonDir/filter2/ex4/commonDir/filter1/ex3' : '',
    'commonDir/filter1/ex' : false,
    'commonDir/filter1/ex1' : false,
    'commonDir/filter1/ex4' : false,
    'commonDir/filter2/ex' : false,
    'commonDir/filter2/ex2' : false,
    'commonDir/filter2/ex3' : false
  }
  var expectedBasePath =
  {
    'commonDir/filter2/f/commonDir/filter1/f' : 'commonDir/filter2/proto/commonDir/filter1/proto',
    'commonDir/filter2/d/commonDir/filter1/f' : 'commonDir/filter2/proto/commonDir/filter1/proto',
    'commonDir/filter2/f2/commonDir/filter1/f' : 'commonDir/filter2/proto/commonDir/filter1/proto',
    'commonDir/filter2/d2/commonDir/filter1/f' : 'commonDir/filter2/proto/commonDir/filter1/proto',
    'commonDir/filter2/ex4/commonDir/filter1/f' : 'commonDir/filter2/proto/commonDir/filter1/proto',
    'commonDir/filter2/f/commonDir/filter1/d' : 'commonDir/filter2/proto/commonDir/filter1/proto',
    'commonDir/filter2/d/commonDir/filter1/d' : 'commonDir/filter2/proto/commonDir/filter1/proto',
    'commonDir/filter2/f2/commonDir/filter1/d' : 'commonDir/filter2/proto/commonDir/filter1/proto',
    'commonDir/filter2/d2/commonDir/filter1/d' : 'commonDir/filter2/proto/commonDir/filter1/proto',
    'commonDir/filter2/ex4/commonDir/filter1/d' : 'commonDir/filter2/proto/commonDir/filter1/proto',
    'commonDir/filter2/f/commonDir/filter1/f1' : 'commonDir/filter2/proto/commonDir/filter1/proto',
    'commonDir/filter2/d/commonDir/filter1/f1' : 'commonDir/filter2/proto/commonDir/filter1/proto',
    'commonDir/filter2/f2/commonDir/filter1/f1' : 'commonDir/filter2/proto/commonDir/filter1/proto',
    'commonDir/filter2/d2/commonDir/filter1/f1' : 'commonDir/filter2/proto/commonDir/filter1/proto',
    'commonDir/filter2/ex4/commonDir/filter1/f1' : 'commonDir/filter2/proto/commonDir/filter1/proto',
    'commonDir/filter2/f/commonDir/filter1/d1' : 'commonDir/filter2/proto/commonDir/filter1/proto',
    'commonDir/filter2/d/commonDir/filter1/d1' : 'commonDir/filter2/proto/commonDir/filter1/proto',
    'commonDir/filter2/f2/commonDir/filter1/d1' : 'commonDir/filter2/proto/commonDir/filter1/proto',
    'commonDir/filter2/d2/commonDir/filter1/d1' : 'commonDir/filter2/proto/commonDir/filter1/proto',
    'commonDir/filter2/ex4/commonDir/filter1/d1' : 'commonDir/filter2/proto/commonDir/filter1/proto',
    'commonDir/filter2/f/commonDir/filter1/ex3' : 'commonDir/filter2/proto/commonDir/filter1/proto',
    'commonDir/filter2/d/commonDir/filter1/ex3' : 'commonDir/filter2/proto/commonDir/filter1/proto',
    'commonDir/filter2/f2/commonDir/filter1/ex3' : 'commonDir/filter2/proto/commonDir/filter1/proto',
    'commonDir/filter2/d2/commonDir/filter1/ex3' : 'commonDir/filter2/proto/commonDir/filter1/proto',
    'commonDir/filter2/ex4/commonDir/filter1/ex3' : 'commonDir/filter2/proto/commonDir/filter1/proto',
  }

  test.identical( f3.prefixPath, null );
  test.identical( f3.filePath, expectedFilePath );
  test.identical( f3.basePath, expectedBasePath );

  /* */

  test.case = 'multiple';

  var f1 = provider.recordFilter();
  f1.prefixPath = '/commonDir';
  f1.filePath = { '/commonDir/*exclude*' : false }

  var f2 = provider.recordFilter();
  f2.prefixPath = '/commonDir';
  f2.filePath = { 'filter1/f' : 'out/dir' }
  f1.pathsInherit( f2 );
  test.identical( f1.prefixPath, null );
  test.identical( f1.basePath, null );
  // test.identical( f1.filePath, { '/commonDir/*exclude*' : 0, '/commonDir' : 'out/dir', '/commonDir/filter1/f' : 'out/dir' } );
  test.identical( f1.filePath, { '/commonDir/*exclude*' : false, '/commonDir' : 'out/dir' } );
  test.identical( f2.prefixPath, null );
  test.identical( f2.basePath, null );
  // test.identical( f2.filePath, { '/commonDir/filter1/f' : 'out/dir' } );
  test.identical( f2.filePath, { '/commonDir/filter1/f' : 'out/dir' } );

  var f3 = provider.recordFilter();
  f3.prefixPath = '/commonDir';
  f3.filePath = { 'filter1/f' : 'out/dir' }
  f1.pathsInherit( f3 );
  // test.identical( f1.prefixPath, '/commonDir' );
  test.identical( f1.prefixPath, null );
  test.identical( f1.basePath, null );
  // test.identical( f1.filePath, { '/commonDir/*exclude*' : false, '/commonDir/filter1/f' : '/commonDir/out/dir' } );
  test.identical( f1.filePath, { '/commonDir/*exclude*' : false, '/commonDir' : 'out/dir/out/dir' } );
  // test.identical( f3.prefixPath, '/commonDir' );
  test.identical( f3.prefixPath, null );
  test.identical( f3.basePath, null );
  // test.identical( f3.filePath, { 'filter1/f' : 'out/dir' } );
  test.identical( f3.filePath, { '/commonDir/filter1/f' : 'out/dir'} );

  var f4 = provider.recordFilter();
  f4.prefixPath = '/commonDir/filter1'
  f4.filePath = { 'f' : 'out/dir' }
  f1.pathsInherit( f4 );
  test.identical( f1.prefixPath, null );
  test.identical( f1.basePath, null );
  // test.identical( f1.filePath, { '/commonDir/*exclude*' : false, '/commonDir/filter1/f' : '/commonDir/out/dir' } );
  test.identical( f1.filePath, { '/commonDir/*exclude*' : false, '/commonDir' : 'out/dir/out/dir/out/dir' } );
  test.identical( f4.prefixPath, null );
  test.identical( f4.basePath, null );
  // test.identical( f4.filePath, { '/commonDir/filter1/f' : '/commonDir/filter1/out/dir' } );
  test.identical( f4.filePath, { '/commonDir/filter1/f' : 'out/dir' } );

  var f5 = provider.recordFilter();
  f5.filePath = { '/commonDir/filter1/f' : '/commonDir/out/dir' }
  f1.pathsInherit( f5 );
  test.identical( f1.prefixPath, null );
  test.identical( f1.basePath, null );
  // test.identical( f1.filePath, { '/commonDir/*exclude*' : false, '/commonDir/filter1/f' : '/commonDir/out/dir' } );
  test.identical( f1.filePath, { '/commonDir/*exclude*' : false, '/commonDir' : '/commonDir/out/dir/out/dir/out/dir/out/dir' } );
  test.identical( f5.prefixPath, null );
  test.identical( f5.basePath, null );
  test.identical( f5.filePath, { '/commonDir/filter1/f' : '/commonDir/out/dir' } );

  /* extra */

  test.case = 'dst.file = map without src, src.file = map';

  var f1 = provider.recordFilter();
  f1.filePath = { '' : '/dst/a' };

  var f2 = provider.recordFilter();
  f2.filePath = { '/src/dir1' : '/dst2', '/src/dir2' : null, '/src/dir3' : '' };

  var f3 = provider.recordFilter();

  f3.pathsInherit( f1 );
  test.identical( f3.prefixPath, null );
  test.identical( f3.filePath, { '' : '/dst/a' } );
  test.identical( f3.basePath, null );

  f3.pathsInherit( f2 );
  test.identical( f3.prefixPath, null );
  test.identical( f3.filePath, { '/src/dir1' : '/dst/a', '/src/dir2' : '/dst/a', '/src/dir3' : '/dst/a' } );
  test.identical( f3.basePath, null );

  /* */

  test.case = 'dst.file = map without src, src.file = map';

  var f1 = provider.recordFilter();
  f1.filePath = { '/src01' : '', '/src02' : null, '/src03' : '/dst03' };

  var f2 = provider.recordFilter();
  f2.filePath = { '/src/dir1' : '/dst2', '/src/dir2' : null, '/src/dir3' : '', '/src/dir4' : '/dst4' };

  var f3 = provider.recordFilter();

  f3.pathsInherit( f1 );
  test.identical( f3.prefixPath, null );
  test.identical( f3.filePath, { '/src01' : '', '/src02' : '', '/src03' : '/dst03' } );
  test.identical( f3.basePath, null );

  f3.pathsInherit( f2 );
  test.identical( f3.prefixPath, null );
  test.identical( f3.filePath, { '/src01' : [ '/dst2', '/dst4' ], '/src02' : [ '/dst2', '/dst4' ], '/src03' : '/dst03' } );
  test.identical( f3.basePath, null );

  /* */

  test.case = 'dst.file = single dot, src.file = map, src.base = str';

  var f1 = provider.recordFilter();
  f1.filePath = { '.' : '/dst/a' };

  var f2 = provider.recordFilter();
  f2.filePath = { '/src/dir' : null, '/src/dir/a' : null };
  f2.basePath = '/src/dir';

  var f3 = provider.recordFilter();

  f3.pathsInherit( f1 );
  test.identical( f3.prefixPath, null );
  test.identical( f3.filePath, { '.' : '/dst/a' } );
  test.identical( f3.basePath, null );

  f3.pathsInherit( f2 );
  test.identical( f3.prefixPath, null );
  test.identical( f3.filePath, { '/src/dir' : '/dst/a', '/src/dir/a' : '/dst/a' } );
  test.identical( f3.basePath, '/src/dir' );

  /* */

  test.case = 'src.file = single dot, dst.file = map, dst.base = map';

  var f1 = provider.recordFilter();
  f1.filePath = { '.' : '/dst' };

  var f2 = provider.recordFilter();
  f2.filePath = { '/src/dir' : null, '/src/dir/a' : null, '/src/dir/b' : null };
  f2.basePath = { '/src/dir' : '/src', '/src/dir/a' : '/src', '/src/dir/b' : '/src' };

  var f3 = provider.recordFilter();

  f3.pathsInherit( f1 );
  test.identical( f3.prefixPath, null );
  test.identical( f3.filePath, { '.' : '/dst' } );
  test.identical( f3.basePath, null );

  f3.pathsInherit( f2 );
  test.identical( f3.prefixPath, null );
  test.identical( f3.filePath, { '/src/dir' : '/dst', '/src/dir/a' : '/dst', '/src/dir/b' : '/dst' } );
  test.identical( f3.basePath, { '/src/dir' : '/src', '/src/dir/a' : '/src', '/src/dir/b' : '/src' } );

  /* */

}

//

function pathsInheritOnlyFilePath( test )
{
  let context = this;
  let provider = new _.FileProvider.Extract();
  let path = provider.path;

  /* */

  test.case = 'src rel string, dst rel string';

  var f1 = provider.recordFilter();
  f1.filePath = 'a';

  var f2 = provider.recordFilter();
  f2.filePath = 'b';

  var f3 = provider.recordFilter();
  f3.pathsInherit( f1 ).pathsInherit( f2 );

  test.identical( f3.prefixPath, null );
  test.identical( f3.filePath, 'b/a' );
  test.identical( f3.basePath, null );

  /* */

  test.case = 'src abs string, dst abs string';

  var f1 = provider.recordFilter();
  f1.filePath = '/a';

  var f2 = provider.recordFilter();
  f2.filePath = '/b';

  var f3 = provider.recordFilter();
  f3.pathsInherit( f1 ).pathsInherit( f2 );

  test.identical( f3.prefixPath, null );
  test.identical( f3.filePath, '/a' );
  test.identical( f3.basePath, null );

  /* */

  test.case = 'dst is map with only src';

  var dst = provider.recordFilter();
  dst.filePath = { "/dir/debug" : '' };

  var src = provider.recordFilter();

  dst.pathsExtendJoining( src );

  test.identical( dst.prefixPath, null );
  test.identical( dst.filePath, '/dir/debug' );
  test.identical( dst.basePath, null );

  test.identical( src.prefixPath, null );
  test.identical( src.filePath, null );
  test.identical( src.basePath, null );

  /* */

  test.case = 'dst is map with only src, paired dst';

  var dst = provider.recordFilter();
  dst.filePath = { "/dir/debug" : '' };
  var dstSrc = provider.recordFilter();
  dstSrc.pairWithDst( dst )
  dstSrc.pairRefineLight();

  var src = provider.recordFilter();

  dst.pathsExtendJoining( src );

  test.identical( dst.prefixPath, null );
  test.identical( dst.filePath, { "/dir/debug" : '' } );
  test.identical( dst.basePath, null );

  test.identical( src.prefixPath, null );
  test.identical( src.filePath, null );
  test.identical( src.basePath, null );

  debugger; return; xxx
}

//

function pathsExtendJoiningOnlyBasePath( test )
{
  let context = this;
  let provider = new _.FileProvider.Extract();
  let path = provider.path;

  /* */

  test.case = 'dst base is string, src base is string';

  var dst = provider.recordFilter();
  dst.basePath = '/dst/base';

  var src = provider.recordFilter();
  src.basePath = '.';

  dst.pathsExtendJoining( src );

  test.identical( dst.prefixPath, null );
  test.identical( dst.filePath, null );
  test.identical( dst.basePath, '/dst/base' );

  /* */

  test.case = 'dst base is string, src base is string';

  var dst = provider.recordFilter();
  dst.basePath = 'dst/base';

  var src = provider.recordFilter();
  src.basePath = 'src/base';

  dst.pathsExtendJoining( src );

  test.identical( dst.prefixPath, null );
  test.identical( dst.filePath, null );
  test.identical( dst.basePath, 'dst/base/src/base' );

  /* */

  test.case = 'dst base is map with no src, src base is string';

  var f1 = provider.recordFilter();
  f1.basePath = { '' : 'dst/base' };

  var f2 = provider.recordFilter();
  f2.basePath = 'src/base';

  var f3 = provider.recordFilter();
  f3.pathsExtendJoining( f1 ).pathsExtendJoining( f2 );

  test.identical( f3.prefixPath, null );
  test.identical( f3.filePath, null );
  test.identical( f3.basePath, 'dst/base/src/base' );

  /* */

  test.case = 'dst base is map, src base is string';

  var f1 = provider.recordFilter();
  f1.basePath = { '.' : 'dst/base' };

  var f2 = provider.recordFilter();
  f2.basePath = 'src/base';

  var f3 = provider.recordFilter();
  f3.pathsExtendJoining( f1 ).pathsExtendJoining( f2 );

  test.identical( f3.prefixPath, null );
  test.identical( f3.filePath, null );
  test.identical( f3.basePath, 'src/base' );

  /* */

  test.case = 'dst base is string, src base is map';

  var f1 = provider.recordFilter();
  f1.basePath = 'dst/base';

  var f2 = provider.recordFilter();
  f2.basePath = { '.' : 'src/base' };

  var f3 = provider.recordFilter();
  f3.pathsExtendJoining( f1 ).pathsExtendJoining( f2 );

  test.identical( f3.prefixPath, null );
  test.identical( f3.filePath, null );
  test.identical( f3.basePath, { '.' : 'src/base' } );

  /* */

  test.case = 'dst base is map, src base is map, collising';

  var f1 = provider.recordFilter();
  f1.basePath = { '.' : 'dst/base' };

  var f2 = provider.recordFilter();
  f2.basePath = { '.' : 'src/base' };

  var f3 = provider.recordFilter();
  f3.pathsExtendJoining( f1 ).pathsExtendJoining( f2 );

  test.identical( f3.prefixPath, null );
  test.identical( f3.filePath, null );
  test.identical( f3.basePath, { '.' : 'dst/base/src/base' } );

  /* */

  test.case = 'dst base is map, src base is map, no collising';

  var f1 = provider.recordFilter();
  f1.basePath = { 'dst' : 'dst/base' };

  var f2 = provider.recordFilter();
  f2.basePath = { 'src' : 'src/base' };

  var f3 = provider.recordFilter();
  f3.pathsExtendJoining( f1 ).pathsExtendJoining( f2 );

  test.identical( f3.prefixPath, null );
  test.identical( f3.filePath, null );
  test.identical( f3.basePath, { 'src' : 'src/base' } );

}

//

function pathsSupplementJoiningLogical( test )
{
  let context = this;
  let provider = new _.FileProvider.Extract();
  let path = provider.path;

  /* - */

  test.open( 'no prefixes, both bases are rel str' );

  test.case = 'both file path map of dst does not has non-bool';

  var dst = provider.recordFilter();
  dst.prefixPath = null;
  dst.basePath = './proto';
  dst.filePath =
  {
    'f' : true,
    'd' : true,
    'ex' : false,
    'f2' : true,
    'd2' : true,
    'ex2' : false,
    'ex3' : false,
    'ex4' : true,
  }

  var src = provider.recordFilter();
  src.prefixPath = null;
  src.basePath = './proto';
  src.filePath =
  {
    'f' : true,
    'd' : true,
    'ex' : false,
    'f1' : true,
    'd1' : true,
    'ex1' : false,
    'ex3' : true,
    'ex4' : false,
  }

  dst.pathsSupplementJoining( src );

  var expectedFilePath =
  {
    'f' : true,
    'd' : true,
    'ex' : false,
    'f2' : true,
    'd2' : true,
    'ex2' : false,
    'ex3' : false,
    'ex4' : true,
    'f1' : true,
    'd1' : true,
    'ex1' : false
  }

  var expectedBasePath = './proto/proto';

  test.identical( dst.prefixPath, null );
  test.identical( dst.filePath, expectedFilePath );
  test.identical( dst.basePath, expectedBasePath );

  var expectedFilePath =
  {
    'f' : true,
    'd' : true,
    'ex' : false,
    'f1' : true,
    'd1' : true,
    'ex1' : false,
    'ex3' : true,
    'ex4' : false
  }

  var expectedBasePath = './proto';

  test.identical( src.prefixPath, null );
  test.identical( src.filePath, expectedFilePath );
  test.identical( src.basePath, expectedBasePath );

  /**/

  test.case = 'both file path map of dst has non-bool';

  var dst = provider.recordFilter();
  dst.prefixPath = null;
  dst.basePath = './proto';
  dst.filePath =
  {
    'f' : true,
    'd' : true,
    'ex' : false,
    'f2' : true,
    'd2' : true,
    'ex2' : false,
    'ex3' : false,
    'ex4' : true,
    '.' : ''
  }

  var src = provider.recordFilter();
  src.prefixPath = null;
  src.basePath = './proto';
  src.filePath =
  {
    'f' : true,
    'd' : true,
    'ex' : false,
    'f1' : true,
    'd1' : true,
    'ex1' : false,
    'ex3' : true,
    'ex4' : false,
    '.' : '',
  }

  dst.pathsSupplementJoining( src );

  var expectedFilePath =
  {
    'f' : true,
    'd' : true,
    'ex' : false,
    'f2' : true,
    'd2' : true,
    'ex2' : false,
    'ex3' : false,
    'ex4' : true,
    'f1' : true,
    'd1' : true,
    'ex1' : false,
    '.' : '',
  }

  var expectedBasePath = { '.' : './proto/proto' }

  test.identical( dst.prefixPath, null );
  test.identical( dst.filePath, expectedFilePath );
  test.identical( dst.basePath, expectedBasePath );

  var expectedFilePath =
  {
    'f' : true,
    'd' : true,
    'ex' : false,
    'f1' : true,
    'd1' : true,
    'ex1' : false,
    'ex3' : true,
    'ex4' : false,
    '.' : ''
  }
  var expectedBasePath = './proto';

  test.identical( src.prefixPath, null );
  test.identical( src.filePath, expectedFilePath );
  test.identical( src.basePath, expectedBasePath );

  /**/

  test.case = 'file path map of dst has non-bool';

  var dst = provider.recordFilter();
  dst.prefixPath = null;
  dst.basePath = './proto';
  dst.filePath =
  {
    'f' : true,
    'd' : true,
    'ex' : false,
    'f2' : true,
    'd2' : true,
    'ex2' : false,
    'ex3' : false,
    'ex4' : true,
    '.' : ''
  }

  var src = provider.recordFilter();
  src.prefixPath = null;
  src.basePath = './proto';
  src.filePath =
  {
    'f' : true,
    'd' : true,
    'ex' : false,
    'f1' : true,
    'd1' : true,
    'ex1' : false,
    'ex3' : true,
    'ex4' : false,
  }

  dst.pathsSupplementJoining( src );

  var expectedFilePath =
  {
    '.' : '',
    'f' : true,
    'd' : true,
    'ex' : false,
    'f2' : true,
    'd2' : true,
    'ex2' : false,
    'ex3' : false,
    'ex4' : true,
    'f1' : true,
    'd1' : true,
    'ex1' : false
  }

  var expectedBasePath = { '.' : './proto/proto' }

  test.identical( dst.prefixPath, null );
  test.identical( dst.filePath, expectedFilePath );
  test.identical( dst.basePath, expectedBasePath );

  var expectedFilePath =
  {
    'f' : true,
    'd' : true,
    'ex' : false,
    'f1' : true,
    'd1' : true,
    'ex1' : false,
    'ex3' : true,
    'ex4' : false
  }

  var expectedBasePath = './proto';

  test.identical( src.prefixPath, null );
  test.identical( src.filePath, expectedFilePath );
  test.identical( src.basePath, expectedBasePath );

  /**/

  test.case = 'file path map of src has non-bool';

  var dst = provider.recordFilter();
  dst.prefixPath = null;
  dst.basePath = './proto';
  dst.filePath =
  {
    'f' : true,
    'd' : true,
    'ex' : false,
    'f2' : true,
    'd2' : true,
    'ex2' : false,
    'ex3' : false,
    'ex4' : true,
  }

  var src = provider.recordFilter();
  src.prefixPath = null;
  src.basePath = './proto';
  src.filePath =
  {
    'f' : true,
    'd' : true,
    'ex' : false,
    'f1' : true,
    'd1' : true,
    'ex1' : false,
    'ex3' : true,
    'ex4' : false,
    '.' : '',
  }

  dst.pathsSupplementJoining( src );

  var expectedFilePath =
  {
    '.' : '',
    'f' : true,
    'd' : true,
    'ex' : false,
    'f2' : true,
    'd2' : true,
    'ex2' : false,
    'ex3' : false,
    'ex4' : true,
    'f1' : true,
    'd1' : true,
    'ex1' : false
  }

  var expectedBasePath = { '.' : './proto/proto' }

  test.identical( dst.prefixPath, null );
  test.identical( dst.filePath, expectedFilePath );
  test.identical( dst.basePath, expectedBasePath );

  var expectedFilePath =
  {
    'f' : true,
    'd' : true,
    'ex' : false,
    'f1' : true,
    'd1' : true,
    'ex1' : false,
    'ex3' : true,
    'ex4' : false,
    '.' : ''
  }

  var expectedBasePath = './proto';

  test.identical( src.prefixPath, null );
  test.identical( src.filePath, expectedFilePath );
  test.identical( src.basePath, expectedBasePath );

  test.close( 'no prefixes, both bases are rel str' );

  /* - */

  test.open( 'both prefixes are abs str, both bases are rel str' );

  test.case = 'both file path map of dst does not has non-bool';

  var dst = provider.recordFilter();
  dst.prefixPath = '/commonDir/dst';
  dst.basePath = './proto';
  dst.filePath =
  {
    'f' : true,
    'd' : true,
    'ex' : false,
    'f2' : true,
    'd2' : true,
    'ex2' : false,
    'ex3' : false,
    'ex4' : true,
  }

  var src = provider.recordFilter();
  src.prefixPath = '/commonDir/src';
  src.basePath = './proto';
  src.filePath =
  {
    'f' : true,
    'd' : true,
    'ex' : false,
    'f1' : true,
    'd1' : true,
    'ex1' : false,
    'ex3' : true,
    'ex4' : false,
  }

  dst.pathsSupplementJoining( src );

  var expectedFilePath =
  {
    '/commonDir/src/f' : true,
    '/commonDir/src/d' : true,
    '/commonDir/src/ex' : false,
    '/commonDir/src/f1' : true,
    '/commonDir/src/d1' : true,
    '/commonDir/src/ex1' : false,
    '/commonDir/src/ex3' : true,
    '/commonDir/src/ex4' : false,
    '/commonDir/dst' : '',
    '/commonDir/dst/f' : true,
    '/commonDir/dst/d' : true,
    '/commonDir/dst/ex' : false,
    '/commonDir/dst/f2' : true,
    '/commonDir/dst/d2' : true,
    '/commonDir/dst/ex2' : false,
    '/commonDir/dst/ex3' : false,
    '/commonDir/dst/ex4' : true
  }

  var expectedBasePath = { '/commonDir/dst' : '/commonDir/dst/proto' }

  test.identical( dst.prefixPath, null );
  test.identical( dst.filePath, expectedFilePath );
  test.identical( dst.basePath, expectedBasePath );

  var expectedFilePath =
  {
    '/commonDir/src' : '',
    '/commonDir/src/f' : true,
    '/commonDir/src/d' : true,
    '/commonDir/src/ex' : false,
    '/commonDir/src/f1' : true,
    '/commonDir/src/d1' : true,
    '/commonDir/src/ex1' : false,
    '/commonDir/src/ex3' : true,
    '/commonDir/src/ex4' : false,
  }

  var expectedBasePath = '/commonDir/src/proto';

  test.identical( src.prefixPath, null );
  test.identical( src.filePath, expectedFilePath );
  test.identical( src.basePath, expectedBasePath );

  /**/

  test.case = 'both file path map of dst has non-bool';

  var dst = provider.recordFilter();
  dst.prefixPath = '/commonDir/dst';
  dst.basePath = './proto';
  dst.filePath =
  {
    'f' : true,
    'd' : true,
    'ex' : false,
    'f2' : true,
    'd2' : true,
    'ex2' : false,
    'ex3' : false,
    'ex4' : true,
    '.' : ''
  }

  var src = provider.recordFilter();
  src.prefixPath = '/commonDir/src';
  src.basePath = './proto';
  src.filePath =
  {
    'f' : true,
    'd' : true,
    'ex' : false,
    'f1' : true,
    'd1' : true,
    'ex1' : false,
    'ex3' : true,
    'ex4' : false,
    '.' : '',
  }

  dst.pathsSupplementJoining( src );

  var expectedFilePath =
  {
    '/commonDir/src/f' : true,
    '/commonDir/src/d' : true,
    '/commonDir/src/ex' : false,
    '/commonDir/src/f1' : true,
    '/commonDir/src/d1' : true,
    '/commonDir/src/ex1' : false,
    '/commonDir/src/ex3' : true,
    '/commonDir/src/ex4' : false,
    '/commonDir/dst' : '',
    '/commonDir/dst/f' : true,
    '/commonDir/dst/d' : true,
    '/commonDir/dst/ex' : false,
    '/commonDir/dst/f2' : true,
    '/commonDir/dst/d2' : true,
    '/commonDir/dst/ex2' : false,
    '/commonDir/dst/ex3' : false,
    '/commonDir/dst/ex4' : true
  }

  var expectedBasePath = { '/commonDir/dst' : '/commonDir/dst/proto' }

  test.identical( dst.prefixPath, null );
  test.identical( dst.filePath, expectedFilePath );
  test.identical( dst.basePath, expectedBasePath );

  var expectedFilePath =
  {
    '/commonDir/src' : '',
    '/commonDir/src/f' : true,
    '/commonDir/src/d' : true,
    '/commonDir/src/ex' : false,
    '/commonDir/src/f1' : true,
    '/commonDir/src/d1' : true,
    '/commonDir/src/ex1' : false,
    '/commonDir/src/ex3' : true,
    '/commonDir/src/ex4' : false,
  }

  var expectedBasePath = '/commonDir/src/proto';

  test.identical( src.prefixPath, null );
  test.identical( src.filePath, expectedFilePath );
  test.identical( src.basePath, expectedBasePath );

  /**/

  test.case = 'file path map of dst has non-bool';

  var dst = provider.recordFilter();
  dst.prefixPath = '/commonDir/dst';
  dst.basePath = './proto';
  dst.filePath =
  {
    'f' : true,
    'd' : true,
    'ex' : false,
    'f2' : true,
    'd2' : true,
    'ex2' : false,
    'ex3' : false,
    'ex4' : true,
    '.' : ''
  }

  var src = provider.recordFilter();
  src.prefixPath = '/commonDir/src';
  src.basePath = './proto';
  src.filePath =
  {
    'f' : true,
    'd' : true,
    'ex' : false,
    'f1' : true,
    'd1' : true,
    'ex1' : false,
    'ex3' : true,
    'ex4' : false,
  }

  dst.pathsSupplementJoining( src );

  var expectedFilePath =
  {
    '/commonDir/src/f' : true,
    '/commonDir/src/d' : true,
    '/commonDir/src/ex' : false,
    '/commonDir/src/f1' : true,
    '/commonDir/src/d1' : true,
    '/commonDir/src/ex1' : false,
    '/commonDir/src/ex3' : true,
    '/commonDir/src/ex4' : false,
    '/commonDir/dst' : '',
    '/commonDir/dst/f' : true,
    '/commonDir/dst/d' : true,
    '/commonDir/dst/ex' : false,
    '/commonDir/dst/f2' : true,
    '/commonDir/dst/d2' : true,
    '/commonDir/dst/ex2' : false,
    '/commonDir/dst/ex3' : false,
    '/commonDir/dst/ex4' : true
  }

  var expectedBasePath = { '/commonDir/dst' : '/commonDir/dst/proto' }

  test.identical( dst.prefixPath, null );
  test.identical( dst.filePath, expectedFilePath );
  test.identical( dst.basePath, expectedBasePath );

  var expectedFilePath =
  {
    '/commonDir/src/f' : true,
    '/commonDir/src/d' : true,
    '/commonDir/src/ex' : false,
    '/commonDir/src/f1' : true,
    '/commonDir/src/d1' : true,
    '/commonDir/src/ex1' : false,
    '/commonDir/src/ex3' : true,
    '/commonDir/src/ex4' : false,
    '/commonDir/src' : '',
  }

  var expectedBasePath = '/commonDir/src/proto';

  test.identical( src.prefixPath, null );
  test.identical( src.filePath, expectedFilePath );
  test.identical( src.basePath, expectedBasePath );

  /**/

  test.case = 'file path map of src has non-bool';

  var dst = provider.recordFilter();
  dst.prefixPath = '/commonDir/dst';
  dst.basePath = './proto';
  dst.filePath =
  {
    'f' : true,
    'd' : true,
    'ex' : false,
    'f2' : true,
    'd2' : true,
    'ex2' : false,
    'ex3' : false,
    'ex4' : true,
  }

  var src = provider.recordFilter();
  src.prefixPath = '/commonDir/src';
  src.basePath = './proto';
  src.filePath =
  {
    'f' : true,
    'd' : true,
    'ex' : false,
    'f1' : true,
    'd1' : true,
    'ex1' : false,
    'ex3' : true,
    'ex4' : false,
    '.' : '',
  }

  dst.pathsSupplementJoining( src );

  var expectedFilePath =
  {
    '/commonDir/src/f' : true,
    '/commonDir/src/d' : true,
    '/commonDir/src/ex' : false,
    '/commonDir/src/f1' : true,
    '/commonDir/src/d1' : true,
    '/commonDir/src/ex1' : false,
    '/commonDir/src/ex3' : true,
    '/commonDir/src/ex4' : false,
    '/commonDir/dst' : '',
    '/commonDir/dst/f' : true,
    '/commonDir/dst/d' : true,
    '/commonDir/dst/ex' : false,
    '/commonDir/dst/f2' : true,
    '/commonDir/dst/d2' : true,
    '/commonDir/dst/ex2' : false,
    '/commonDir/dst/ex3' : false,
    '/commonDir/dst/ex4' : true
  }

  var expectedBasePath = { '/commonDir/dst' : '/commonDir/dst/proto' }

  test.identical( dst.prefixPath, null );
  test.identical( dst.filePath, expectedFilePath );
  test.identical( dst.basePath, expectedBasePath );

  var expectedFilePath =
  {
    '/commonDir/src/f' : true,
    '/commonDir/src/d' : true,
    '/commonDir/src/ex' : false,
    '/commonDir/src/f1' : true,
    '/commonDir/src/d1' : true,
    '/commonDir/src/ex1' : false,
    '/commonDir/src/ex3' : true,
    '/commonDir/src/ex4' : false,
    '/commonDir/src' : ''
  }

  var expectedBasePath = '/commonDir/src/proto';

  test.identical( src.prefixPath, null );
  test.identical( src.filePath, expectedFilePath );
  test.identical( src.basePath, expectedBasePath );

  test.close( 'both prefixes are abs str, both bases are rel str' );

  debugger; return; xxx
}

// //
//
// function pathsJoin()
// {
//   let context = this;
//   let provider = new _.FileProvider.Extract();
//   let path = provider.path;
//
//   var dst = provider.recordFilter();
//   dst.basePath = '/base';
//
//   var src = provider.recordFilter();
//   src.filePath = '/base/src1/**';
//
//   dst.pathsJoin( src );
//   test.identical( dst.prefixPath, null );
//   test.identical( dst.basePath, '/base' );
//   test.identical( dst.filePath, '/base/src1/**' );
//   test.identical( src.prefixPath, null );
//   test.identical( src.basePath, null );
//   test.identical( src.filePath, '/base/src1/**' );
//
// }

//

function pairRefineLight( test )
{
  let provider = _.fileProvider;

  /* */

  test.case = 'empty';

  var src = provider.recordFilter();
  var dst = provider.recordFilter();
  src.pairWithDst( dst )
  src.pairRefineLight();

  test.identical( src.hasAnyPath(), false );
  test.identical( src.filePath, null );
  test.identical( src.prefixPath, null );
  test.identical( src.postfixPath, null );
  test.identical( src.basePath, null );

  test.identical( dst.hasAnyPath(), false );
  test.identical( dst.filePath, null );
  test.identical( dst.prefixPath, null );
  test.identical( dst.postfixPath, null );
  test.identical( dst.basePath, null );

  /* */

  test.case = 'pair, src.file - map, dst.file - string, dst.prefix - string';

  var src = provider.recordFilter();
  src.filePath = { '.' : null };
  src.prefixPath = '/a/b';
  src.postfixPath = null;
  src.basePath = null;

  var dst = provider.recordFilter();
  dst.filePath = '/a/dst/file';
  dst.prefixPath = '/a/dst';
  dst.postfixPath = null;
  dst.basePath = null;

  test.identical( src.hasAnyPath(), true );
  test.identical( dst.hasAnyPath(), true );
  src.pairWithDst( dst )
  src.pairRefineLight();
  test.identical( src.hasAnyPath(), true );
  test.identical( dst.hasAnyPath(), true );
  test.is( src.filePath === dst.filePath );
  test.is( _.mapIs( src.filePath ) );

  test.identical( src.filePath, { '.' : '/a/dst/file' } );
  test.identical( src.prefixPath, '/a/b' );
  test.identical( src.postfixPath, null );
  test.identical( src.basePath, null );
  test.identical( dst.filePath, { '.' : '/a/dst/file' } );
  test.identical( dst.prefixPath, '/a/dst' );
  test.identical( dst.postfixPath, null );
  test.identical( dst.basePath, null );

  /* */

  test.case = 'pair, src.file - map, src.prefix - str, dst.file - string, dst.prefix - string, dst.file - str';

  var src = provider.recordFilter();
  src.filePath = { c : 'c2', d : null };
  src.prefixPath = '/src';
  src.postfixPath = null;
  src.basePath = null;

  var dst = provider.recordFilter();
  dst.filePath = 'dir';
  dst.prefixPath = '/dst';
  dst.postfixPath = null;
  dst.basePath = null;

  test.identical( src.hasAnyPath(), true );
  test.identical( dst.hasAnyPath(), true );
  src.pairWithDst( dst )
  src.pairRefineLight();
  test.identical( src.hasAnyPath(), true );
  test.identical( dst.hasAnyPath(), true );
  test.is( src.filePath === dst.filePath );
  test.is( _.mapIs( src.filePath ) );

  test.identical( src.filePath, { 'c' : 'c2', 'd' : 'dir' } );
  test.identical( src.prefixPath, '/src' );
  test.identical( src.postfixPath, null );
  test.identical( src.basePath, null );
  test.identical( dst.filePath, { 'c' : 'c2', 'd' : 'dir' } );
  test.identical( dst.prefixPath, '/dst' );
  test.identical( dst.postfixPath, null );
  test.identical( dst.basePath, null );

  /* */

  test.case = 'pair, src.file - map, src.prefix - str, dst.file - string, dst.prefix - string, dst.file - .';

  var src = provider.recordFilter();
  src.filePath = { c : 'c2', d : null };
  src.prefixPath = '/src';
  src.postfixPath = null;
  src.basePath = null;

  var dst = provider.recordFilter();
  dst.filePath = '.';
  dst.prefixPath = '/dst';
  dst.postfixPath = null;
  dst.basePath = null;

  test.identical( src.hasAnyPath(), true );
  test.identical( dst.hasAnyPath(), true );
  src.pairWithDst( dst )
  src.pairRefineLight();
  test.identical( src.hasAnyPath(), true );
  test.identical( dst.hasAnyPath(), true );
  test.is( src.filePath === dst.filePath );
  test.is( _.mapIs( src.filePath ) );

  test.identical( src.filePath, { 'c' : 'c2', 'd' : '.' } );
  test.identical( src.prefixPath, '/src' );
  test.identical( src.postfixPath, null );
  test.identical( src.basePath, null );
  test.identical( dst.filePath, { 'c' : 'c2', 'd' : '.' } );
  test.identical( dst.prefixPath, '/dst' );
  test.identical( dst.postfixPath, null );
  test.identical( dst.basePath, null );

  /* */

  test.case = 'src.file - only map';

  var osrc =
  {
    filePath : { '/src' : '/dst' }
  }
  var odst =
  {
  }

  var src = provider.recordFilter( osrc );
  var dst = provider.recordFilter( odst );
  test.identical( src.formed, 1 );
  test.identical( dst.formed, 1 );

  src.pairWithDst( dst );
  src.pairRefineLight();

  test.identical( src.formed, 1 );
  test.identical( dst.formed, 1 );
  test.identical( src.filePath, { '/src' : '/dst' } );
  test.identical( dst.filePath, { '/src' : '/dst' } );
  test.is( src.filePath === dst.filePath );

  /* */

  test.case = 'src.file - only map, with only true';

  var osrc =
  {
    filePath : { '/src' : true }
  }
  var odst =
  {
  }

  var src = provider.recordFilter( osrc );
  var dst = provider.recordFilter( odst );
  test.identical( src.formed, 1 );
  test.identical( dst.formed, 1 );

  src.pairWithDst( dst );
  src.pairRefineLight();

  test.identical( src.formed, 1 );
  test.identical( dst.formed, 1 );
  test.identical( src.filePath, { '/src' : true } );
  test.identical( dst.filePath, { '/src' : true } );
  test.is( src.filePath === dst.filePath );

  /* */

  test.case = 'src.file - only map with bools';

  var osrc =
  {
    filePath : { '/src' : true, '/src2' : '/dst2' }
  }
  var odst =
  {
  }

  var src = provider.recordFilter( osrc );
  var dst = provider.recordFilter( odst );
  test.identical( src.formed, 1 );
  test.identical( dst.formed, 1 );

  src.pairWithDst( dst );
  src.pairRefineLight();

  test.identical( src.formed, 1 );
  test.identical( dst.formed, 1 );
  test.identical( src.filePath, { '/src' : true, '/src2' : '/dst2' } );
  test.identical( dst.filePath, { '/src' : true, '/src2' : '/dst2' } );
  test.is( src.filePath === dst.filePath );

  /* */

  test.case = 'dst.file - only map';

  var osrc =
  {
  }
  var odst =
  {
    filePath : { '/src' : '/dst' }
  }

  var src = provider.recordFilter( osrc );
  var dst = provider.recordFilter( odst );
  test.identical( src.formed, 1 );
  test.identical( dst.formed, 1 );

  src.pairWithDst( dst );
  src.pairRefineLight();

  test.identical( src.formed, 1 );
  test.identical( dst.formed, 1 );
  test.identical( src.filePath, { '/src' : '/dst' } );
  test.identical( dst.filePath, { '/src' : '/dst' } );
  test.is( src.filePath === dst.filePath );

  /* */

  test.case = 'dst.file - only map, with only true';

  var osrc =
  {
  }
  var odst =
  {
    filePath : { '/src' : true }
  }

  var src = provider.recordFilter( osrc );
  var dst = provider.recordFilter( odst );
  test.identical( src.formed, 1 );
  test.identical( dst.formed, 1 );

  src.pairWithDst( dst );
  src.pairRefineLight();

  test.identical( src.formed, 1 );
  test.identical( dst.formed, 1 );
  test.identical( src.filePath, { '/src' : true } );
  test.identical( dst.filePath, { '/src' : true } );
  test.is( src.filePath === dst.filePath );

  /* */

  test.case = 'dst.file - only map, with true';

  var osrc =
  {
  }
  var odst =
  {
    filePath : { '/src' : true, '/src2' : '/dst' }
  }

  var src = provider.recordFilter( osrc );
  var dst = provider.recordFilter( odst );
  test.identical( src.formed, 1 );
  test.identical( dst.formed, 1 );

  src.pairWithDst( dst );
  src.pairRefineLight();

  test.identical( src.formed, 1 );
  test.identical( dst.formed, 1 );
  test.identical( src.filePath, { '/src' : true, '/src2' : '/dst' } );
  test.identical( dst.filePath, { '/src' : true, '/src2' : '/dst' } );
  test.is( src.filePath === dst.filePath );

  /* */

  test.case = 'dst.file - only map, with null';

  var osrc =
  {
  }
  var odst =
  {
    filePath : { '/src' : null, '/src2' : '/dst' }
  }

  var src = provider.recordFilter( osrc );
  var dst = provider.recordFilter( odst );
  test.identical( src.formed, 1 );
  test.identical( dst.formed, 1 );

  src.pairWithDst( dst );
  src.pairRefineLight();

  test.identical( src.formed, 1 );
  test.identical( dst.formed, 1 );
  test.identical( src.filePath, { '/src' : '', '/src2' : '/dst' } );
  test.identical( dst.filePath, { '/src' : '', '/src2' : '/dst' } );
  test.is( src.filePath === dst.filePath );

  /* */

  test.case = 'src.file - map, dst.file - map';

  var osrc =
  {
    filePath : { '/src' : '/dst' }
  }
  var odst =
  {
    filePath : { '/src' : '/dst' }
  }

  var src = provider.recordFilter( osrc );
  var dst = provider.recordFilter( odst );
  test.identical( src.formed, 1 );
  test.identical( dst.formed, 1 );

  src.pairWithDst( dst );
  src.pairRefineLight();

  test.identical( src.formed, 1 );
  test.identical( dst.formed, 1 );
  test.identical( src.filePath, { '/src' : '/dst' } );
  test.identical( dst.filePath, { '/src' : '/dst' } );
  test.is( src.filePath === dst.filePath );

  /* */

  test.case = 'src.file - map, dst.file - string';

  var osrc =
  {
    filePath : { '/src' : '/dst' }
  }
  var odst =
  {
    filePath : '/dst'
  }

  var src = provider.recordFilter( osrc );
  var dst = provider.recordFilter( odst );
  test.identical( src.formed, 1 );
  test.identical( dst.formed, 1 );

  src.pairWithDst( dst );
  src.pairRefineLight();

  test.identical( src.formed, 1 );
  test.identical( dst.formed, 1 );
  test.identical( src.filePath, { '/src' : '/dst' } );
  test.identical( dst.filePath, { '/src' : '/dst' } );
  test.is( src.filePath === dst.filePath );

  /* */

  test.case = 'src.file - string, dst.file - map';

  var osrc =
  {
    filePath : '/src'
  }
  var odst =
  {
    filePath : { '/src' : '/dst' }
  }

  var src = provider.recordFilter( osrc );
  var dst = provider.recordFilter( odst );
  test.identical( src.formed, 1 );
  test.identical( dst.formed, 1 );

  src.pairWithDst( dst );
  src.pairRefineLight();

  test.identical( src.formed, 1 );
  test.identical( dst.formed, 1 );
  test.identical( src.filePath, { '/src' : '/dst' } );
  test.identical( dst.filePath, { '/src' : '/dst' } );
  test.is( src.filePath === dst.filePath );

  /* */

  test.case = 'src.file - string, dst.file - string';

  var osrc =
  {
    filePath : '/src'
  }
  var odst =
  {
    filePath : '/dst'
  }

  var src = provider.recordFilter( osrc );
  var dst = provider.recordFilter( odst );
  test.identical( src.formed, 1 );
  test.identical( dst.formed, 1 );

  src.pairWithDst( dst );
  src.pairRefineLight();

  test.identical( src.formed, 1 );
  test.identical( dst.formed, 1 );
  test.identical( src.filePath, { '/src' : '/dst' } );
  test.identical( dst.filePath, { '/src' : '/dst' } );
  test.is( src.filePath === dst.filePath );

  /* */

  test.case = 'src.file - only string';

  var osrc =
  {
    filePath : '/src'
  }
  var odst =
  {
  }

  var src = provider.recordFilter( osrc );
  var dst = provider.recordFilter( odst );
  test.identical( src.formed, 1 );
  test.identical( dst.formed, 1 );

  src.pairWithDst( dst );
  src.pairRefineLight();

  test.identical( src.formed, 1 );
  test.identical( dst.formed, 1 );
  test.identical( src.filePath, { '/src' : '' } );
  test.identical( dst.filePath, { '/src' : '' } );
  test.is( src.filePath === dst.filePath );

  /* */

  test.case = 'dst.file - only string';

  var osrc =
  {
  }
  var odst =
  {
    filePath : '/dst'
  }

  var src = provider.recordFilter( osrc );
  var dst = provider.recordFilter( odst );
  test.identical( src.formed, 1 );
  test.identical( dst.formed, 1 );

  src.pairWithDst( dst );
  src.pairRefineLight();

  test.identical( src.formed, 1 );
  test.identical( dst.formed, 1 );
  test.identical( src.filePath, { '' : '/dst' } );
  test.identical( dst.filePath, { '' : '/dst' } );
  test.is( src.filePath === dst.filePath );

  /* */

  test.case = 'dst.file - map without dst, src.file - map without dst';

  var osrc =
  {
    filePath : { '.' : true },
  }
  var odst =
  {
    filePath : { '.' : true },
  }

  var src = provider.recordFilter( osrc );
  var dst = provider.recordFilter( odst );
  test.identical( src.formed, 1 );
  test.identical( dst.formed, 1 );

  src.pairWithDst( dst );
  src.pairRefineLight();

  test.identical( src.formed, 1 );
  test.identical( dst.formed, 1 );
  test.identical( src.filePath, { '.' : true } );
  test.identical( dst.filePath, { '.' : true } );

  /* */

  test.case = 'dst.file - map without dst, src.file - map without dst, src.prefix';

  var osrc =
  {
    filePath : { '.' : true },
    prefixPath : '/a/b',
  }
  var odst =
  {
    filePath : { '.' : true },
  }

  var src = provider.recordFilter( osrc );
  var dst = provider.recordFilter( odst );
  test.identical( src.formed, 1 );
  test.identical( dst.formed, 1 );

  src.pairWithDst( dst );
  src.pairRefineLight();

  test.identical( src.formed, 1 );
  test.identical( dst.formed, 1 );
  test.identical( src.prefixPath, '/a/b' );
  test.identical( src.filePath, { '.' : true } );
  test.identical( dst.filePath, { '.' : true } );
  test.is( dst.filePath === src.filePath );

  /* */

  test.case = 'dst.file - map without dst, dst.prefix, src.file - map without dst';

  var osrc =
  {
    filePath : { '.' : null },
  }
  var odst =
  {
    filePath : { '.' : null },
    prefixPath : '/a/b',
  }

  var src = provider.recordFilter( osrc );
  var dst = provider.recordFilter( odst );
  test.identical( src.formed, 1 );
  test.identical( dst.formed, 1 );

  src.pairWithDst( dst );
  src.pairRefineLight();

  test.identical( src.formed, 1 );
  test.identical( src.prefixPath, null );
  test.identical( src.filePath, { '.' : '' } );
  test.identical( dst.formed, 1 );
  test.identical( dst.prefixPath, '/a/b' );
  test.identical( dst.filePath, { '.' : '' } );
  test.is( dst.filePath === src.filePath );

  /* */

  test.case = 'src.file - map, dst.file - string, both prefixes';

  var osrc =
  {
    prefixPath : '/',
    filePath : { '**.js' : null, '**.s' : null },
  }
  var odst =
  {
    prefixPath : '/',
    filePath : '/dst/dir',
  }

  var src = provider.recordFilter( osrc );
  var dst = provider.recordFilter( odst );
  test.identical( src.formed, 1 );
  test.identical( dst.formed, 1 );

  src.pairWithDst( dst );
  src.pairRefineLight();

  test.identical( src.formed, 1 );
  test.identical( src.prefixPath, '/' );
  test.identical( src.filePath, { '**.js' : '/dst/dir', '**.s' : '/dst/dir' } );
  test.identical( src.basePath, null );

  test.identical( dst.formed, 1 );
  test.identical( dst.prefixPath, '/' );
  test.identical( dst.filePath, { '**.js' : '/dst/dir', '**.s' : '/dst/dir' } );
  test.identical( dst.basePath, null );

  test.is( dst.filePath === src.filePath );

  /* */

  test.case = 'src.file - map, dst.file - string, redundant dst';

  var osrc =
  {
    filePath : { '/src' : '/dst1' },
  }
  var odst =
  {
    filePath : '/dst2',
  }

  var src = provider.recordFilter( osrc );
  var dst = provider.recordFilter( odst );
  test.identical( src.formed, 1 );
  test.identical( dst.formed, 1 );

  src.pairWithDst( dst );
  src.pairRefineLight();

  test.identical( src.formed, 1 );
  test.identical( src.prefixPath, null );
  test.identical( src.filePath, { '/src' : '/dst1' } );
  test.identical( src.basePath, null );

  test.identical( dst.formed, 1 );
  test.identical( dst.prefixPath, null );
  test.identical( dst.filePath, { '/src' : '/dst1' } );
  test.identical( dst.basePath, null );

  test.is( dst.filePath === src.filePath );

  /* */

  test.case = 'second after pairing forming';

  var src = provider.recordFilter();
  src.filePath = '/';
  var dst = provider.recordFilter();
  dst.filePath = '/';

  src.pairWithDst( dst )
  src.pairRefineLight();
  test.is( src.filePath === dst.filePath );

  test.identical( src.filePath, { '/' : '/' } );
  test.identical( src.prefixPath, null );
  test.identical( src.postfixPath, null );
  test.identical( src.basePath, null );
  test.identical( dst.filePath, { '/' : '/' } );
  test.identical( dst.prefixPath, null );
  test.identical( dst.postfixPath, null );
  test.identical( dst.basePath, null );

  src.form();
  dst.form();

  test.identical( src.filePath, { '/' : '/' } );
  test.identical( src.prefixPath, null );
  test.identical( src.postfixPath, null );
  test.identical( src.basePath, { '/' : '/' } );
  test.identical( dst.filePath, { '/' : '/' } );
  test.identical( dst.prefixPath, null );
  test.identical( dst.postfixPath, null );
  test.identical( dst.basePath, null );

  src.pairWithDst( dst )
  src.pairRefineLight();

  test.identical( src.filePath, { '/' : '/' } );
  test.identical( src.prefixPath, null );
  test.identical( src.postfixPath, null );
  test.identical( src.basePath, { '/' : '/' } );
  test.identical( dst.filePath, { '/' : '/' } );
  test.identical( dst.prefixPath, null );
  test.identical( dst.postfixPath, null );
  test.identical( dst.basePath, null );

  /* - */

  if( Config.debug )
  {
    test.open( 'throwing' );

    test.case = 'src.file - map, dst.file - map, inconsistant src';
    var src = provider.recordFilter({ filePath : { '/src1' : '/dst' } });
    var dst = provider.recordFilter({ filePath : { '/src2' : '/dst' } });
    src.pairWithDst( dst );
    test.shouldThrowErrorSync( () => src.pairRefineLight() );

    test.case = 'src.file - string, dst.file - map, inconsistant src';
    var src = provider.recordFilter({ filePath : '/src1' });
    var dst = provider.recordFilter({ filePath : { '/src2' : '/dst' } });
    src.pairWithDst( dst );
    test.shouldThrowErrorSync( () => src.pairRefineLight() );

    test.case = 'src.file - map, dst.file - map, inconsistant dst';
    var src = provider.recordFilter({ filePath : { '/src' : '/dst1' } });
    var dst = provider.recordFilter({ filePath : { '/src' : '/dst2' } });
    src.pairWithDst( dst );
    test.shouldThrowErrorSync( () => src.pairRefineLight() );

    test.case = 'src.file - map, dst.file - map, inconsistant dst';
    var src = provider.recordFilter({ filePath : { '/src' : true } });
    var dst = provider.recordFilter({ filePath : { '/src' : null } });
    src.pairWithDst( dst );
    test.shouldThrowErrorSync( () => src.pairRefineLight() );

    test.close( 'throwing' );
  }

}

//

function moveTextualReport( test )
{
  let provider = new _.FileProvider.Extract();

  /* */

  test.case = 'empty';
  var src = provider.recordFilter();
  var dst = provider.recordFilter();
  src.pairWithDst( dst )
  src.pairRefineLight();
  var expected = '{null} : . <- .';
  var got = src.moveTextualReport();
  test.identical( _.color.strStrip( got ), expected );
  var got = dst.moveTextualReport();
  test.identical( _.color.strStrip( got ), expected );

  /* */

  test.case = 'src.file, no refine';
  var src = provider.recordFilter();
  src.filePath = '/src';
  var dst = provider.recordFilter();
  src.pairWithDst( dst )
  var expected = '/{null} <- /src';
  var got = src.moveTextualReport();
  test.identical( _.color.strStrip( got ), expected );
  var got = dst.moveTextualReport();
  test.identical( _.color.strStrip( got ), expected );

  /* */

  test.case = 'dst.file, no refine';
  var src = provider.recordFilter();
  var dst = provider.recordFilter();
  dst.filePath = '/dst';
  src.pairWithDst( dst );
  var expected = '/dst <- /{null}';
  var got = src.moveTextualReport();
  test.identical( _.color.strStrip( got ), expected );
  var got = dst.moveTextualReport();
  test.identical( _.color.strStrip( got ), expected );

  /* */

  test.case = 'src.file, dst.file, no refine';
  var src = provider.recordFilter();
  src.filePath = '/src';
  var dst = provider.recordFilter();
  dst.filePath = '/dst';
  src.pairWithDst( dst )
  var expected = '/dst <- /src';
  var got = src.moveTextualReport();
  test.identical( _.color.strStrip( got ), expected );
  var got = dst.moveTextualReport();
  test.identical( _.color.strStrip( got ), expected );

  /* */

  test.case = 'src.file, dst.file, refine';
  var src = provider.recordFilter();
  src.filePath = '/src';
  var dst = provider.recordFilter();
  dst.filePath = '/dst';
  src.pairWithDst( dst )
  var expected = '/dst <- /src';
  var got = src.moveTextualReport();
  test.identical( _.color.strStrip( got ), expected );
  var got = dst.moveTextualReport();
  test.identical( _.color.strStrip( got ), expected );

  /* */

  test.case = 'src.file, dst.file, refine';
  var src = provider.recordFilter();
  src.filePath = '/common/src';
  var dst = provider.recordFilter();
  dst.filePath = '/common/dst';
  src.pairWithDst( dst )
  var expected = '/common/ : dst <- src';
  var got = src.moveTextualReport();
  test.identical( _.color.strStrip( got ), expected );
  var got = dst.moveTextualReport();
  test.identical( _.color.strStrip( got ), expected );

  /* */

  test.case = 'src.file, dst.file, src.prefix, dst.prefix, refine';
  var src = provider.recordFilter();
  src.filePath = './src';
  src.prefixPath = '/common';
  var dst = provider.recordFilter();
  dst.filePath = './dst';
  dst.prefixPath = '/common';
  src.pairWithDst( dst )
  var expected = '/common/ : dst <- src';
  var got = src.moveTextualReport();
  test.identical( _.color.strStrip( got ), expected );
  var got = dst.moveTextualReport();
  test.identical( _.color.strStrip( got ), expected );

  /* */

}

//

function filePathSimplest( test )
{
  let provider = _.fileProvider;

  /* */

  test.case = 'empty';
  var src = provider.recordFilter();
  var dst = provider.recordFilter();
  src.pairWithDst( dst )
  src.pairRefineLight();
  var expected = null;
  var got = src.filePathSimplest();
  test.identical( got, expected );
  var expected = null;
  var got = dst.filePathSimplest();
  test.identical( got, expected );

  /* */

  test.case = 'src.file, no refine';
  var src = provider.recordFilter();
  src.filePath = '/src';
  var dst = provider.recordFilter();
  src.pairWithDst( dst )
  var expected = '/src';
  var got = src.filePathSimplest();
  test.identical( got, expected );
  var expected = null;
  var got = dst.filePathSimplest();
  test.identical( got, expected );

  /* */

  test.case = 'dst.file, no refine';
  var src = provider.recordFilter();
  var dst = provider.recordFilter();
  dst.filePath = '/dst';
  src.pairWithDst( dst )
  var expected = null;
  var got = src.filePathSimplest();
  test.identical( got, expected );
  var expected = '/dst';
  var got = dst.filePathSimplest();
  test.identical( got, expected );

  /* */

  test.case = 'src.file, dst.file, no refine';
  var src = provider.recordFilter();
  src.filePath = '/src';
  var dst = provider.recordFilter();
  dst.filePath = '/dst';
  src.pairWithDst( dst )
  var expected = '/src';
  var got = src.filePathSimplest();
  test.identical( got, expected );
  var expected = '/dst';
  var got = dst.filePathSimplest();
  test.identical( got, expected );

  /* */

  test.case = 'src.file, dst.file, refine';
  var src = provider.recordFilter();
  src.filePath = '/src';
  var dst = provider.recordFilter();
  dst.filePath = '/dst';
  src.pairWithDst( dst )
  var expected = '/src';
  var got = src.filePathSimplest();
  test.identical( got, expected );
  var expected = '/dst';
  var got = dst.filePathSimplest();
  test.identical( got, expected );

  /* */

  test.case = 'src.file, dst.file, refine';
  var src = provider.recordFilter();
  src.filePath = '/common/src';
  var dst = provider.recordFilter();
  dst.filePath = '/common/dst';
  src.pairWithDst( dst )
  var expected = '/common/src';
  var got = src.filePathSimplest();
  test.identical( got, expected );
  var expected = '/common/dst';
  var got = dst.filePathSimplest();
  test.identical( got, expected );

  /* */

  test.case = 'src.file, dst.file, src.prefix, dst.prefix, refine';
  var src = provider.recordFilter();
  src.filePath = './src';
  src.prefixPath = '/common';
  var dst = provider.recordFilter();
  dst.filePath = './dst';
  dst.prefixPath = '/common';
  src.pairWithDst( dst )
  var expected = './src';
  var got = src.filePathSimplest();
  test.identical( got, expected );
  var expected = './dst';
  var got = dst.filePathSimplest();
  test.identical( got, expected );

  /* */

}

//

function hasAnyPath( test )
{
  let provider = _.fileProvider;

  var src = provider.recordFilter();
  test.identical( src.formed, 1 );

  test.case = 'trivial';
  test.identical( src.hasAnyPath(), false );

  test.case = 'file path';
  src.filePath = '/a/b';
  src.prefixPath = null;
  src.postfixPath = null;
  src.basePath = null;
  test.identical( src.hasAnyPath(), true );

  test.case = 'prefix path';
  src.filePath = null;
  src.prefixPath = '/a/b';
  src.postfixPath = null;
  src.basePath = null;
  test.identical( src.hasAnyPath(), true );

  test.case = 'posftix path';
  src.filePath = null;
  src.prefixPath = null;
  src.postfixPath = '/a/b';
  src.basePath = null;
  test.identical( src.hasAnyPath(), true );

  test.case = 'bae path';
  src.filePath = null;
  src.prefixPath = null;
  src.postfixPath = null;
  src.basePath = '/a/b';
  test.identical( src.hasAnyPath(), true );

  test.case = 'pair, file path map';
  var src = provider.recordFilter();
  src.filePath = '/a/b';
  src.prefixPath = null;
  src.postfixPath = null;
  src.basePath = null;
  var dst = provider.recordFilter();
  dst.filePath = null;
  dst.prefixPath = null;
  dst.postfixPath = null;
  dst.basePath = null;
  test.identical( src.hasAnyPath(), true );
  test.identical( dst.hasAnyPath(), false );
  src.pairWithDst( dst )
  src.pairRefineLight();
  test.identical( src.hasAnyPath(), true );
  test.identical( dst.hasAnyPath(), false );
  test.is( src.filePath === dst.filePath );
  test.is( _.mapIs( src.filePath ) );

  test.case = 'src.file = dot, dst.file = null';
  var src = provider.recordFilter();
  src.filePath = '.';
  src.prefixPath = null;
  src.postfixPath = null;
  src.basePath = null;
  var dst = provider.recordFilter();
  dst.filePath = null;
  dst.prefixPath = null;
  dst.postfixPath = null;
  dst.basePath = null;
  test.identical( src.hasAnyPath(), false );
  test.identical( dst.hasAnyPath(), false );
  src.pairWithDst( dst )
  src.pairRefineLight();
  test.identical( src.hasAnyPath(), false );
  test.identical( dst.hasAnyPath(), false );
  test.identical( src.filePath, { '.' : '' } );
  test.is( src.filePath === dst.filePath );

  test.case = 'src.file = dot, dst.file = dot';
  var src = provider.recordFilter();
  src.filePath = '.';
  src.prefixPath = null;
  src.postfixPath = null;
  src.basePath = null;
  var dst = provider.recordFilter();
  dst.filePath = '.';
  dst.prefixPath = null;
  dst.postfixPath = null;
  dst.basePath = null;
  test.identical( src.hasAnyPath(), false );
  test.identical( dst.hasAnyPath(), false );
  src.pairWithDst( dst )
  test.identical( src.hasAnyPath(), false );
  test.identical( dst.hasAnyPath(), true );
  src.pairRefineLight();
  test.identical( src.hasAnyPath(), false );
  test.identical( dst.hasAnyPath(), true );
  test.identical( src.filePath, { '.' : '.' } );
  test.is( src.filePath === dst.filePath );

}

//

function filePathSelect( test )
{
  let provider = _.fileProvider;

  var filter = provider.recordFilter();
  filter.filePath =
  {
    '/src' : '/dst',
    '/src/**.test*' : true,
    '/src/**.release*' : false,
  }
  filter.basePath = '/';
  test.identical( filter.formed, 1 );

  var srcPath =
  {
    '/src' : '/dst',
    '/src/**.test*' : true,
    '/src/**.release*' : false,
  }
  var dstPath = '/dst';

  filter.filePathSelect( srcPath, dstPath );

  test.identical( filter.formed, 5 );
  test.identical( filter.filePath, { '/src' : '/dst', '/src/**.test*' : true, '/src/**.release*' : false } );
  test.identical( filter.basePath, { '/src' : '/' } );
  test.identical( filter.prefixPath, null );
  test.identical( filter.postfixPath, null );

}

//

function filePathArrayGet( test )
{
  let provider = _.fileProvider;

  /* */

  test.case = 'src.file - string, not refined paring';
  var src = provider.recordFilter();
  src.filePath = '/ab';
  var dst = provider.recordFilter();
  dst.filePath = null;
  src.pairWithDst( dst )

  test.description = 'filePathDstArrayNonBoolGet, boolFallingBack : 0';
  var expected = [ null ];
  var got = src.filePathDstArrayNonBoolGet( src.filePath, 0 );
  test.identical( got, expected );
  var expected = [];
  var got = dst.filePathDstArrayNonBoolGet( dst.filePath, 0 );
  test.identical( got, expected );
  test.description = 'filePathDstArrayNonBoolGet, boolFallingBack : 1';
  var expected = [ null ];
  var got = src.filePathDstArrayNonBoolGet( src.filePath, 1 );
  test.identical( got, expected );
  var expected = [];
  var got = dst.filePathDstArrayNonBoolGet( dst.filePath, 1 );
  test.identical( got, expected );

  test.description = 'filePathSrcArrayNonBoolGet, boolFallingBack : 0';
  var expected = [ '/ab' ];
  var got = src.filePathSrcArrayNonBoolGet( src.filePath, 0 );
  test.identical( got, expected );
  var expected = [];
  var got = dst.filePathSrcArrayNonBoolGet( dst.filePath, 0 );
  test.identical( got, expected );
  test.description = 'filePathSrcArrayNonBoolGet, boolFallingBack : 1';
  var expected = [ '/ab' ];
  var got = src.filePathSrcArrayNonBoolGet( src.filePath, 1 );
  test.identical( got, expected );
  var expected = [];
  var got = dst.filePathSrcArrayNonBoolGet( dst.filePath, 1 );
  test.identical( got, expected );

  test.description = 'filePathDstArrayBoolGet';
  var expected = [];
  var got = src.filePathDstArrayBoolGet( src.filePath );
  test.identical( got, expected );
  var got = dst.filePathDstArrayBoolGet( dst.filePath );
  test.identical( got, expected );

  test.description = 'filePathSrcArrayBoolGet';
  var expected = [];
  var got = src.filePathSrcArrayBoolGet( src.filePath );
  test.identical( got, expected );
  var got = dst.filePathSrcArrayBoolGet( dst.filePath );
  test.identical( got, expected );

  /* */

  test.case = 'dst.file - string, not refined paring';
  var src = provider.recordFilter();
  src.filePath = null;
  var dst = provider.recordFilter();
  dst.filePath = '/ab';
  src.pairWithDst( dst )

  test.description = 'filePathDstArrayNonBoolGet, boolFallingBack : 0';
  var expected = [];
  var got = src.filePathDstArrayNonBoolGet( src.filePath, 0 );
  test.identical( got, expected );
  var expected = [ '/ab' ];
  var got = dst.filePathDstArrayNonBoolGet( dst.filePath, 0 );
  test.identical( got, expected );
  test.description = 'filePathDstArrayNonBoolGet, boolFallingBack : 1';
  var expected = [];
  var got = src.filePathDstArrayNonBoolGet( src.filePath, 1 );
  test.identical( got, expected );
  var expected = [ '/ab' ];
  var got = dst.filePathDstArrayNonBoolGet( dst.filePath, 1 );
  test.identical( got, expected );

  test.description = 'filePathSrcArrayNonBoolGet, boolFallingBack : 0';
  var expected = [];
  var got = src.filePathSrcArrayNonBoolGet( src.filePath, 0 );
  test.identical( got, expected );
  var expected = [ null ];
  var got = dst.filePathSrcArrayNonBoolGet( dst.filePath, 0 );
  test.identical( got, expected );
  test.description = 'filePathSrcArrayNonBoolGet, boolFallingBack : 1';
  var expected = [];
  var got = src.filePathSrcArrayNonBoolGet( src.filePath, 1 );
  test.identical( got, expected );
  var expected = [ null ];
  var got = dst.filePathSrcArrayNonBoolGet( dst.filePath, 1 );
  test.identical( got, expected );

  test.description = 'filePathDstArrayBoolGet';
  var expected = [];
  var got = src.filePathDstArrayBoolGet( src.filePath );
  test.identical( got, expected );
  var got = dst.filePathDstArrayBoolGet( dst.filePath );
  test.identical( got, expected );

  test.description = 'filePathSrcArrayBoolGet';
  var expected = [];
  var got = src.filePathSrcArrayBoolGet( src.filePath );
  test.identical( got, expected );
  var got = dst.filePathSrcArrayBoolGet( dst.filePath );
  test.identical( got, expected );

  /* */

  test.case = 'src.file - complex array, not refined paring';
  var src = provider.recordFilter();
  src.filePath = [ '/ab', '/cd', '/ab', null ];
  var dst = provider.recordFilter();
  dst.filePath = null;
  src.pairWithDst( dst )

  test.description = 'filePathDstArrayNonBoolGet, boolFallingBack : 0';
  var expected = [ null ];
  var got = src.filePathDstArrayNonBoolGet( src.filePath, 0 );
  test.identical( got, expected );
  var expected = [];
  var got = dst.filePathDstArrayNonBoolGet( dst.filePath, 0 );
  test.identical( got, expected );
  test.description = 'filePathDstArrayNonBoolGet, boolFallingBack : 1';
  var expected = [ null ];
  var got = src.filePathDstArrayNonBoolGet( src.filePath, 1 );
  test.identical( got, expected );
  var expected = [];
  var got = dst.filePathDstArrayNonBoolGet( dst.filePath, 1 );
  test.identical( got, expected );

  test.description = 'filePathSrcArrayNonBoolGet, boolFallingBack : 0';
  var expected = [ '/ab', '/cd', null ];
  var got = src.filePathSrcArrayNonBoolGet( src.filePath, 0 );
  test.identical( got, expected );
  var expected = [];
  var got = dst.filePathSrcArrayNonBoolGet( dst.filePath, 0 );
  test.identical( got, expected );
  test.description = 'filePathSrcArrayNonBoolGet, boolFallingBack : 1';
  var expected = [ '/ab', '/cd', null ];
  var got = src.filePathSrcArrayNonBoolGet( src.filePath, 1 );
  test.identical( got, expected );
  var expected = [];
  var got = dst.filePathSrcArrayNonBoolGet( dst.filePath, 1 );
  test.identical( got, expected );

  test.description = 'filePathDstArrayBoolGet';
  var expected = [];
  var got = src.filePathDstArrayBoolGet( src.filePath );
  test.identical( got, expected );
  var got = dst.filePathDstArrayBoolGet( dst.filePath );
  test.identical( got, expected );

  test.description = 'filePathSrcArrayBoolGet';
  var expected = [];
  var got = src.filePathSrcArrayBoolGet( src.filePath );
  test.identical( got, expected );
  var got = dst.filePathSrcArrayBoolGet( dst.filePath );
  test.identical( got, expected );

  /* */

  test.case = 'src.file - single-key map with true in dst';
  var src = provider.recordFilter();
  src.filePath = { '/' : true };
  var dst = provider.recordFilter();
  dst.filePath = null;
  src.pairWithDst( dst )
  src.pairRefineLight();

  test.description = 'filePathDstArrayNonBoolGet, boolFallingBack : 0';
  var expected = [];
  var got = src.filePathDstArrayNonBoolGet( src.filePath, 0 );
  test.identical( got, expected );
  var got = dst.filePathDstArrayNonBoolGet( dst.filePath, 0 );
  test.identical( got, expected );
  test.description = 'filePathDstArrayNonBoolGet, boolFallingBack : 1';
  var expected = [ null ];
  var got = src.filePathDstArrayNonBoolGet( src.filePath, 1 );
  test.identical( got, expected );
  var got = dst.filePathDstArrayNonBoolGet( dst.filePath, 1 );
  test.identical( got, expected );

  test.description = 'filePathSrcArrayNonBoolGet, boolFallingBack : 0';
  var expected = [];
  var got = src.filePathSrcArrayNonBoolGet( src.filePath, 0 );
  test.identical( got, expected );
  var got = dst.filePathSrcArrayNonBoolGet( dst.filePath, 0 );
  test.identical( got, expected );
  test.description = 'filePathSrcArrayNonBoolGet, boolFallingBack : 1';
  var expected = [ '/' ];
  var got = src.filePathSrcArrayNonBoolGet( src.filePath, 1 );
  test.identical( got, expected );
  var got = dst.filePathSrcArrayNonBoolGet( dst.filePath, 1 );
  test.identical( got, expected );

  test.description = 'filePathDstArrayBoolGet';
  var expected = [ true ];
  var got = src.filePathDstArrayBoolGet( src.filePath );
  test.identical( got, expected );
  var got = dst.filePathDstArrayBoolGet( dst.filePath );
  test.identical( got, expected );

  test.description = 'filePathSrcArrayBoolGet';
  var expected = [ '/' ];
  var got = src.filePathSrcArrayBoolGet( src.filePath );
  test.identical( got, expected );
  var got = dst.filePathSrcArrayBoolGet( dst.filePath );
  test.identical( got, expected );

  /* */

  test.case = 'src.file - complex map';
  var src = provider.recordFilter();
  src.filePath = { 'True' : true, 'False' : false, 'Zero' : 0, 'One' : 1, 'Null' : null, 'str' : 'str', 'Array' : [ 'a', 'b' ] };
  var dst = provider.recordFilter();
  dst.filePath = null;
  src.pairWithDst( dst )
  src.pairRefineLight();

  test.description = 'filePathDstArrayNonBoolGet, boolFallingBack : 0';
  var expected = [ '', 'str', 'a', 'b' ];
  var got = src.filePathDstArrayNonBoolGet( src.filePath, 0 );
  test.identical( got, expected );
  var got = dst.filePathDstArrayNonBoolGet( dst.filePath, 0 );
  test.identical( got, expected );
  test.description = 'filePathDstArrayNonBoolGet, boolFallingBack : 1';
  var expected = [ '', 'str', 'a', 'b' ];
  var got = src.filePathDstArrayNonBoolGet( src.filePath, 1 );
  test.identical( got, expected );
  var got = dst.filePathDstArrayNonBoolGet( dst.filePath, 1 );
  test.identical( got, expected );

  test.description = 'filePathSrcArrayNonBoolGet, boolFallingBack : 0';
  var expected = [ 'Null', 'str', 'Array' ];
  var got = src.filePathSrcArrayNonBoolGet( src.filePath, 0 );
  test.identical( got, expected );
  var got = dst.filePathSrcArrayNonBoolGet( dst.filePath, 0 );
  test.identical( got, expected );
  test.description = 'filePathSrcArrayNonBoolGet, boolFallingBack : 1';
  var expected = [ 'Null', 'str', 'Array' ];
  var got = src.filePathSrcArrayNonBoolGet( src.filePath, 1 );
  test.identical( got, expected );
  var got = dst.filePathSrcArrayNonBoolGet( dst.filePath, 1 );
  test.identical( got, expected );

  test.description = 'filePathDstArrayBoolGet';
  var expected = [ true, false ];
  var got = src.filePathDstArrayBoolGet( src.filePath );
  test.identical( got, expected );
  var got = dst.filePathDstArrayBoolGet( dst.filePath );
  test.identical( got, expected );

  test.description = 'filePathSrcArrayBoolGet';
  var expected = [ 'True', 'False', 'Zero', 'One' ];
  var got = src.filePathSrcArrayBoolGet( src.filePath );
  test.identical( got, expected );
  var got = dst.filePathSrcArrayBoolGet( dst.filePath );
  test.identical( got, expected );

  /* */

}

//

function basePathUse( test )
{
  let provider = _.FileProvider.Extract({});

  /* */

  test.case = 'null';

  var f1 = provider.recordFilter();
  f1.prefixPath = 'app1/**';
  f1.filePath = '.';
  var basePath = f1.basePathUse( null );

  test.identical( basePath, '/app1' );
  test.identical( f1.prefixPath, null );
  test.identical( f1.basePath, '/app1' );
  test.identical( f1.filePath, '/app1/**' );

  /* */

  test.case = 'dot';

  var f1 = provider.recordFilter();
  f1.prefixPath = 'app1/**';
  f1.filePath = '.';
  var basePath = f1.basePathUse( '.' );

  test.identical( basePath, '/' );
  test.identical( f1.prefixPath, null );
  test.identical( f1.basePath, '/app1' );
  test.identical( f1.filePath, '/app1/**' );

  /* */

  test.case = 'absolute';

  var f1 = provider.recordFilter();
  f1.prefixPath = 'app1/**';
  f1.filePath = '.';
  var basePath = f1.basePathUse( '/dir' );

  test.identical( basePath, '/dir' );
  test.identical( f1.prefixPath, null );
  test.identical( f1.basePath, '/dir' );
  test.identical( f1.filePath, '/dir/app1/**' );

  /* */

  test.case = 'filter with base';

  var f1 = provider.recordFilter();
  f1.prefixPath = 'app1/**';
  f1.filePath = '.';
  f1.basePath = 'app2';
  var basePath = f1.basePathUse( '.' );

  test.identical( basePath, '/' );
  test.identical( f1.prefixPath, null );
  test.identical( f1.basePath, '/app1/app2' );
  test.identical( f1.filePath, '/app1/**' );

  /* */

}

// --
// declare
// --

var Self =
{

  name : 'Tools/mid/files/RecordFilter',
  silencing : 1,

  onSuiteBegin,
  onSuiteEnd,

  tests :
  {

    make,
    form,
    clone,
    isPaired,

    reflect,
    prefixesApply,
    prefixesRelative,

    pathsExtend,
    pathsExtendJoining,
    pathsInherit,

    pathsInheritOnlyFilePath,
    pathsExtendJoiningOnlyBasePath,

    pathsSupplementJoiningLogical,
    // pathsJoin,

    pairRefineLight,
    moveTextualReport,
    filePathSimplest,

    hasAnyPath,
    filePathSelect,
    filePathArrayGet,
    basePathUse,

  },

}

Self = wTestSuite( Self )
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

} )( );
