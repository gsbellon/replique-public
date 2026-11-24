# Ligne d'appel : voir compare.sh (Rscript aplatit_rdata.R <fichier.Rdata> <sortie.csv>)
# Aplatit chaque objet d'un fichier .Rdata en lignes "cle,valeur" : valeurs numériques à 17 chiffres significatifs,
# autres valeurs en texte. Aucun arrondi, aucune sélection : toute la structure sort (objet, noms, valeurs).
args <- commandArgs(trailingOnly = TRUE)
e <- new.env()
nm <- load(args[1], envir = e)
rows <- list()
for (o in sort(nm)) {
  x <- get(o, envir = e)
  u <- tryCatch(unlist(x, use.names = TRUE), error = function(err) NULL)
  if (is.null(u)) {
    rows[[length(rows) + 1]] <- data.frame(cle = paste0(o, "|structure"),
                                           valeur = paste(capture.output(str(x)), collapse = " / "))
    next
  }
  # un objet atomique à dimensions (matrice) garde ses dimensions sous unlist : on les range en lignes, noms de dimensions en clé
  dn <- dimnames(u)
  if (!is.null(dim(u))) {
    ai <- arrayInd(seq_along(u), dim(u))
    nms <- vapply(seq_along(u), function(i) paste(vapply(seq_len(ncol(ai)), function(k) {
      d <- dn[[k]]; if (is.null(d)) as.character(ai[i, k]) else d[ai[i, k]] }, ""), collapse = "/"), "")
    u <- as.vector(u)
  } else {
    nms <- names(u); if (is.null(nms)) nms <- rep("", length(u))
  }
  keys <- paste0(o, "|", seq_along(u), "|", nms)
  val <- if (is.numeric(u)) formatC(u, digits = 17, format = "g") else as.character(u)
  rows[[length(rows) + 1]] <- data.frame(cle = keys, valeur = as.character(val), stringsAsFactors = FALSE)
  rows[[length(rows) + 1]] <- data.frame(cle = paste0(o, "|classe"), valeur = paste(class(x), collapse = " "))
}
out <- do.call(rbind, rows)
write.csv(out, args[2], row.names = FALSE)
cat(args[1], ":", length(nm), "objets,", nrow(out), "lignes\n")
