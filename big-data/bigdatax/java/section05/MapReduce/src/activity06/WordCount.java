package activity06;

import java.io.IOException;
import java.util.StringTokenizer;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.input.TextInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.mapreduce.lib.output.NullOutputFormat;
import org.apache.hadoop.mapreduce.lib.output.TextOutputFormat;

public class WordCount {
    /**
     * WordCountMap --- The class containing the WordCount mapper.
     */
    public static class WordCountMap extends Mapper<LongWritable, Text, Text, IntWritable> {
        /**
         * Perform whe WordCount mapping.
         */
		public void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
            // tokenize the input text line
			String line = value.toString().toLowerCase();
			StringTokenizer tokenizer = new StringTokenizer(line);

            // add key value pairs for word lengths
            while (tokenizer.hasMoreTokens()) {
                String word = tokenizer.nextToken();
                Text outputValue = new Text(String.valueOf(word.length()));
                context.write(outputValue, new IntWritable(1));
            }


            /* 
            // get the job configuration
            Configuration conf = context.getConfiguration();
            int wordLength = Integer.parseInt(conf.get("word.length"));

            // add words matching the length to the output
            while (tokenizer.hasMoreTokens()) {
                String word = tokenizer.nextToken();
                if (word.length() == wordLength) {
                    //Text outputValue = new Text(word);
                    Text outputValue = new Text(word);
                    context.write(outputValue, new IntWritable(1));
                }
            }
            */
        }
    }

    /**
     * WordCountReduce --- Implement the WordCount reducer.
     */
	public static class WordCountReduce extends Reducer<Text, IntWritable, Text, IntWritable> {
        /**
         * Perform the reduce.
         */
		public void reduce(Text key, Iterable<IntWritable> values,Context context) throws IOException,InterruptedException {
			int sum=0;
			for(IntWritable value : values)
			{
				sum += value.get();
			}
			context.write(key, new IntWritable(sum));
		}
	}

    /**
     * Create and run the MapReduce job.
     * @param args The input file, and the length a word that should be counted.
     * @throws IOException
     * @throws InterruptedException
     * @throws ClassNotFoundException
     */
    public static void main(String[] args) throws IOException, ClassNotFoundException, InterruptedException {
        // set the job configuration
        Configuration conf = new Configuration();
        //conf.set("word.length", args[1]);
        //conf.set("mapreduce.input.keyvaluelinerecordreader.key.value.separator", " ");

        // create the job
		Job job = Job.getInstance(conf);
		job.setJarByClass(WordCount.class);
		job.setJobName("WordCount_Part01");

        // set the map and reducer classes
		job.setMapperClass(WordCountMap.class);
		job.setReducerClass(WordCountReduce.class);

        // set the output key and value classes
		job.setOutputKeyClass(Text.class);
		job.setOutputValueClass(IntWritable.class);

        // set the input and output format
		job.setInputFormatClass(TextInputFormat.class);
		job.setOutputFormatClass(TextOutputFormat.class);
        //job.setOutputFormatClass(NullOutputFormat.class);

        // set the paths to the input and output files
		FileInputFormat.addInputPath(job, new Path(args[0]));
		FileOutputFormat.setOutputPath(job, new Path("section05/MapReduce/src/activity06/output_01/"));


        // start the job and wait for it to complete
        job.waitForCompletion(true);
        System.exit(0);
    }
    
}
