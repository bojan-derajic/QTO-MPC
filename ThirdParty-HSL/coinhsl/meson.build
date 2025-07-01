project('coinhsl', 'fortran', 'c',
  version : '2024.05.15',
  default_options : ['buildtype=release', 'warning_level=3', 'pkgconfig.relocatable=true'])

src = []
headers = []
include_dirs = []
deps = []

install_modules = get_option('modules')
script_modules = files('install_modules.py')

fs = import('fs')
full_install = fs.is_dir('hsl_ma97')

headers += files('CoinHslConfig.h')

dirs = ['common', 'ma27', 'ma28', 'mc19']
if full_install
  dirs += ['hsl_ma77', 'hsl_ma86', 'hsl_ma97', 'hsl_mc68', 'ma57']
endif
foreach name : dirs
  subdir(name)
endforeach

if full_install
  libblas_name = get_option('libblas')
  libblas_path = get_option('libblas_path')

  liblapack_name = get_option('liblapack')
  liblapack_path = get_option('liblapack_path')

  libmetis_name = get_option('libmetis')
  libmetis_path = get_option('libmetis_path')
  libmetis_include = include_directories(get_option('libmetis_include'))
  libmetis_version = get_option('libmetis_version')

  # C and Fortran compilers
  cc = meson.get_compiler('c')
  fc = meson.get_compiler('fortran')

  # OpenMP
  if fc.get_id() == 'nagfor'
    add_global_arguments('-openmp', language : 'fortran')
    add_global_link_arguments('-openmp', language : 'fortran')
  elif fc.get_id() == 'gcc'
    add_global_arguments('-fopenmp', language : 'fortran')
    add_global_link_arguments('-fopenmp', language : 'fortran')
  elif fc.get_id() == 'intel' or fc.get_id() == 'intel-llvm'
    add_global_arguments('-qopenmp', language : 'fortran')
    add_global_link_arguments('-qopenmp', language : 'fortran')
  elif fc.get_id() == 'intel-cl' or fc.get_id() == 'intel-llvm-cl'
    add_global_arguments('/Qopenmp', language : 'fortran')
  endif

  libblas = fc.find_library(libblas_name, dirs : libblas_path, required : true)
  liblapack = fc.find_library(liblapack_name, dirs : liblapack_path, required : true)

  libmetis = fc.find_library(libmetis_name, dirs : libmetis_path, required : false)
  has_metish = cc.has_header('metis.h', include_directories : libmetis_include)

  if fc.get_id() == 'gcc' and fc.version().version_compare('>=10.0')
    add_global_arguments('-fallow-argument-mismatch', language : 'fortran')
  endif

  if fc.get_id() == 'nagfor'
    add_global_arguments('-dcfuns', language : 'fortran')
  endif

  libhsl_src = []

  subdir('metis')

  src += libhsl_src

  include_dirs += libmetis_include

  deps += [libblas, liblapack, libmetis]
endif

lib = library('coinhsl',
        sources : src,
	      dependencies : deps,
        include_directories : include_dirs,
        link_language : 'fortran',
        install : true)

install_headers(headers)

pkg = import('pkgconfig')
pkg.generate(lib,
             description : 'A collection of HSl routines for use with IPOPT')

if install_modules
  meson.add_install_script(script_modules)
endif