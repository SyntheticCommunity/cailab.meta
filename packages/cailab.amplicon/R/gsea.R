#' 执行微生物群落样本级富集分析 (Sample-Level Enrichment Analysis)
#'
#' 该函数接受 phyloseq 对象，针对特定的目标微生物，分析样本元数据特征是否在
#' 该微生物高丰度或低丰度的样本中富集。
#'
#' @param ps A `phyloseq` object.
#' @param target_taxon A character string. The target taxon name (e.g., "Escherichia").
#' @param tax_rank A character string. The rank of the target taxon (e.g., "Genus").
#' @param sample_feat A character string. The metadata column name to group samples (e.g., "Group").
#' @param nperm Integer. Number of permutations for fgsea. Default is 1000.
#' @param min_size Integer. Minimum size of a feature set. Default is 5.
#' @param max_size Integer. Maximum size of a feature set. Default is 500.
#'
#' @return A `data.frame` (tbl_df) containing the GSEA results.
#' Columns include: pathway, pval, padj, NES, size, leadingEdge.
#'
#' @importFrom phyloseq tax_table otu_table sample_names rank_names sample_data taxa_are_rows
#' @importFrom fgsea fgsea
#' @importFrom dplyr arrange desc select
#' @importFrom tibble as_tibble
#'
#' @examples
#' \dontrun{
#' # Suppose there is a ps object.
#' res <- run_microbiome_gsea(
#'     ps = ps,
#'     target_taxon = "Bacillus",
#'     tax_rank = "Genus",
#'     sample_feat = "SampleType"
#' )
#' print(res)
#' }
#' @export
run_microbiome_gsea <- function(ps, target_taxon, tax_rank, sample_feat, 
                                nperm = 1000, min_size = 5, max_size = 500) {
  
  # 1. 获取排序后的丰度向量 (Stats)
  # 这一步包含了 Z-score 标准化
  message(paste("Calculating ranked abundance for:", target_taxon, "..."))
  ranked_stats <- get_sorted_abundance_vector(ps, target_taxon, tax_rank)
  
  # 2. 获取样本特征集合 (Pathways)
  message(paste("Generating sample sets for feature:", sample_feat, "..."))
  sample_pathways <- get_sample_feature_sets(ps, sample_feat, min_size = 3)
  
  # 检查是否有足够的集合进行分析
  if (length(sample_pathways) == 0) {
    stop("No valid sample sets generated. Check your metadata column or min_size.")
  }
  
  # 3. 运行 fgsea
  message("Running GSEA analysis...")
  
  # 设置随机种子以保证结果可重复
  set.seed(123)
  
  gsea_res <- fgsea::fgsea(
    pathways = sample_pathways,
    stats    = ranked_stats,
    minSize  = min_size,
    maxSize  = max_size
  )
  
  return(gsea_res)
  # 4. 结果整理
  # 转换为 tibble 并按 NES (Normalized Enrichment Score) 绝对值或数值排序
  # 这里按 NES 降序排列 (正富集在前，负富集在后)

}
