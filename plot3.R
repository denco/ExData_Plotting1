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
data = subset(data, Date %in% c(as.Date("2007-02-01"), as.Date("2007-02-02")))
data$Timestamp = as.POSIXct(sprintf("%s %s", data$Date, data$Time), "%Y-%m-%d %H:%M:%S")
data$Sub_metering_1 = as.double(data$Sub_metering_1)
data$Sub_metering_2 = as.double(data$Sub_metering_2)
data$Sub_metering_3 = as.double(data$Sub_metering_3)

### create plot
png(file="plot3.png", width = 504, height = 504, bg = "transparent")
plot(
  data$Timestamp,
  data$Sub_metering_1,
  xlab = "",
  ylab = "Energy sub metering",
  col = "black",
  type = "l"
)
points(
  data$Timestamp,
  data$Sub_metering_2,
  xlab = "",
  col = "red",
  type = "l"
)
points(
  data$Timestamp,
  data$Sub_metering_3,
  xlab = "",
  col = "blue",
  type = "l"
)
legend("topright",
       c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       col=c("black","red","blue"),
       lwd=1
)
dev.off()