# Écart numérique entre résultats fournis (/pkg/output) et régénérés (/out), fichier par fichier.
# Pour chaque CSV : mêmes dimensions et mêmes noms de colonnes ? cellules non numériques identiques ?
# plus grand écart absolu et relatif sur les cellules numériques. Aucune statistique du paquet n'est recalculée.
# Ligne d'appel : voir lance_ecarts.sh
a <- "/pkg/output"; b <- "/out"
files <- sort(list.files(a, pattern = "\\.csv$", recursive = TRUE))
cat(sprintf("%-60s %6s %6s %10s %12s %12s\n", "fichier", "forme", "texte", "nb_cell_num", "max_abs", "max_rel"))
worst_abs <- 0; worst_rel <- 0; bad <- 0
for (f in files) {
  x <- read.csv(file.path(a, f), colClasses = "character", check.names = FALSE)
  y <- read.csv(file.path(b, f), colClasses = "character", check.names = FALSE)
  shape <- identical(dim(x), dim(y)) && identical(names(x), names(y))
  if (!shape) { cat(sprintf("%-60s %6s\n", f, "NON")); bad <- bad + 1; next }
  mx <- as.matrix(x); my <- as.matrix(y)
  nx <- suppressWarnings(matrix(as.numeric(mx), nrow(mx))); ny <- suppressWarnings(matrix(as.numeric(my), nrow(my)))
  isnum <- !is.na(nx) & !is.na(ny)
  txt <- all(mx[!isnum] == my[!isnum] | (is.na(mx[!isnum]) & is.na(my[!isnum])))
  d <- abs(nx[isnum] - ny[isnum]); r <- d / pmax(abs(nx[isnum]), abs(ny[isnum]), 1e-300)
  r[d == 0] <- 0
  ma <- if (length(d)) max(d) else 0; mr <- if (length(r)) max(r) else 0
  worst_abs <- max(worst_abs, ma); worst_rel <- max(worst_rel, mr)
  if (!txt) bad <- bad + 1
  cat(sprintf("%-60s %6s %6s %10d %12.3g %12.3g\n", f, "oui", if (txt) "oui" else "NON", sum(isnum), ma, mr))
}
cat(sprintf("\nGLOBAL : %d fichiers CSV ; fichiers à forme ou texte différents : %d ; max_abs = %.3g ; max_rel = %.3g\n",
            length(files), bad, worst_abs, worst_rel))
