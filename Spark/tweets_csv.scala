/*
Reading data from csv files. Experimental.
-- Probably need to use something external, as from databricks:
https://github.com/databricks/spark-csv
*/

cd /root
./spark/bin/spark-shell --driver-memory 7G


import sqlContext.implicits._

val sqlContext = new org.apache.spark.sql.SQLContext(sc)

//  In theory, it should be able to recognize the schema, but it cannot:
val tweets = sqlContext.read.text("csv/clean-tweets_0.csv")
tweets.printSchema  // fail.
tweets.first

// We can try to specify the schema ourselves. First, just load as text:
val tws = sc.textFile("csv/clean-tweets_0.csv")
// Or to load all files: val tws = sc.wholeTextFiles("csv/clean-tweets_*.csv")


// lets look at the header to learn the schema:
val head = tws.take(10)
val header = head(0)
val line = head(1)
val cells = line.split(",")
cells(6)  //  the text of the tweet

// col(0) is just a rownumber, ignore it.
// Here's our parse schema:
def parse(line: String) = {
	val cells = line.split(",")
	val idn = cells(1)
	val time = cells(2)
	val utcoffset = cells(3)
	val hashtags = cells(4)
	val language = cells(5)
	val text = cells(6)
	(idn, time, utcoffset, hashtags, language, text)
}

val tup  = parse(line)
tup._6  // text - works fine for one line.


val parsed = tws.map(line => parse(line))

// cache this in memory:
parsed.cache()

parsed.first
// fails.

