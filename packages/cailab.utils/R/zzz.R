.onLoad <- function(libname, pkgname, meta_file = system.file("cailab-meta.yml", package = "cailab.utils")) {
  
  sub_pkgs <- names(yaml::read_yaml(meta_file)$packages)
  
  for (pkg in sub_pkgs) {
    if (requireNamespace(pkg, quietly = TRUE)) {
      message("[cailab.utils] Loaded: ", pkg)
    } else {
      message("[cailab.utils] Not installed: ", pkg)
    }
  }
}
