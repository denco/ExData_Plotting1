### packages
library(data.table)

### data locations
fileURL = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
data_dir = "./data"
raw_data_zip = "raw_data.zip"
extracted_data = sprintf("%s/%s", data_dir, "household_power_consumption.txt")

### Download file if necessary, unzip if necessary
if (!file.exists(data_dir)) {
    ### create data dir
    dir.create(data_dir)
    
    ### download raw data
    if (!file.exists(raw_data_zip)){
        download.file(fileURL, raw_data_zip, method="curl")
    }
    
    ### unzip raw data
    unzip(raw_data_zip, exdir=data_dir, junkpaths=T)
}

### read data from file
data = suppressWarnings(
        fread(extracted_data,
             header = TRUE,
             stringsAsFactors=FALSE,
             sep=";",
             na.strings = "?",
             colClasses=list(character=1:2, numeric=3:9), ### won't work :/
             )
        )

### Transform date and subsetting data
data$Date = as.Date(data$Date , "%d/%m/%Y")
data$Global_active_power = as.numeric(data$Global_active_power)
data = subset(data, Date %in% c(as.Date("2007-02-01"), as.Date("2007-02-02")))

### create histogramm
png(file="plot1.png", width = 504, height = 504, bg = "transparent")
with(
    data,
    hist(
        Global_active_power,
        main = "Global Active Power",
        xlab = "Global Active Power (kilowatts)",
        col = "red"
    )
)
dev.off()