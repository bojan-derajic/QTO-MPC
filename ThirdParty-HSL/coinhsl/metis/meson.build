if libmetis.found() and libmetis_version == '5' and (not has_metish)
  warning(meson.project_name() + ' can not be compiled with METIS 5 without the header file metis.h. Use the option -Dlibmetis_include to provide the location of metis.h.')
endif

if libmetis.found() and libmetis_version == '4'
  libhsl_src += files('metis4.f90')
elif has_metish and libmetis.found() and libmetis_version == '5'
  libhsl_src += files('metis5_adapter.c', 'metis5.f90')
else
  libhsl_src += files('dummy_metis.f90')
endif
