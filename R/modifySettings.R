library(yaml)
HEISPath           = "D:/HEIS/"
HEISCompressedPath = paste0(HEISPath,"DataCompressed/")
HEISAccessPath     = paste0(HEISPath,"DataAccess/")
HEISRawPath        = paste0(HEISPath,"DataRaw/")
HEISProcessedPath  = paste0(HEISPath,"DataProcessed/")
D80LinkDest        = paste0(HEISAccessPath,"D80Link.accdb")


Settings <- list(HEISPath          =HEISPath,
                 HEISCompressedPath=HEISCompressedPath,
                 HEISAccessPath    =HEISAccessPath,
                 HEISRawPath       =HEISRawPath,
                 HEISProcessedPath =HEISProcessedPath,
                 startyear=69,
                 endyear=93,
                 OS="windows",
                 RawDataWebAddress ="http://www.amar.org.ir/Portals/0/amarmozuii/hazinedaramad/",
                 CompressedFileNamesFile="../Data/CompressedFileNames.csv",
                 weightsFile       ="../Data/AllWeights.rda",
                 D80LinkSource     ="../Data/D80Link.accdb",
                 D80LinkDest       =D80LinkDest
)
write(as.yaml(Settings),file = "Settings.yaml")