test_that("GSEA analysis runs correctly on test data", {
  
  # 直接使用 ps_test_data
  res <- run_microbiome_gsea(
    ps = ps_test_data,
    target_taxon = "Genus1",
    tax_rank = "Genus",
    sample_feat = "Group",
    nperm = 1000,
    min_size = 5
  )
  
  # 检查结果结构
  expect_s3_class(res, "data.frame")
  expect_true("NES" %in% colnames(res))
  
  # 检查生物学逻辑：预期 Group_Treat 的 NES 为正值
  treat_row <- res[res$pathway == "Group_Treat", ]
  expect_true(treat_row$NES > 0)
})

