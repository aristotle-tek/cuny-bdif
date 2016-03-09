
cd /root
./spark/bin/spark-shell --driver-memory 14G

// Can access shell using sys:
import sys.process._
"ls -al" !

val sqlContext = new org.apache.spark.sql.SQLContext(sc)

// for implicitly conversion of an RDD to a DataFrame:
import sqlContext.implicits._


val tweets = sqlContext.read.json("tweets/*.json")

// count - 313,780:
tweets.count

// look at first tweet:
tweets.first

tweets.printSchema
// (Notice how spark inferred this schema)

val head = tweets.take(10)

head.length

head.foreach(println)


// SQL / dataframe queries:
// if you are reducing from a larger set, you need to add collect():

// can get columns by number, e.g. 3rd column is the timestamp:
head.map(t => "Created at: " + t(3)).foreach(println)

// Or get by column name:
head.map(t => "Id string: " + t.getAs[String]("id_str")).foreach(println)
head.map(t => "Text: " + t.getAs[String]("text")).foreach(println)


// Direct dataframes methods:
// Notice the schema has nested elements that we access with dot (.):
tweets.select("user.name").show
tweets.select("user.lang").show

// filter for French tweets:
val fr = tweets.filter(col("user.lang").like("%fr%"))
fr.count

//print all the French tweets (some are not in French - it is a static setting...)
fr.map(t => "Text: " + t.getAs[String]("text")).collect().foreach(println)



// How many tweets include text: "Why" ?
val whys = tweets.filter(col("text").like("%Why%"))
whys.count
//whys.map(t => "Text: " + t.getAs[String]("text")).collect().foreach(println)

val mad = tweets.filter(col("text").like("%mad%"))
//mad.map(t => "Text: " + t.getAs[String]("text")).collect().foreach(println)


//-----------------------------------------------
// load text file, count word occurences:
//-----------------------------------------------
val txt = sc.textFile("tweets/test.txt")

val tokens = txt.flatMap(_.split(" "))
val wordFreq = tokens.map((_, 1)).reduceByKey(_ + _) 

wordFreq.collect.foreach(println)

// just the top results:
wordFreq.map(x => (x._2, x._1)).top(3)




