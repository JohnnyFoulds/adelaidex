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
import org.apache.hadoop.mapreduce.lib.input.KeyValueTextInputFormat;
import org.apache.hadoop.mapreduce.lib.input.SequenceFileInputFormat;
import org.apache.hadoop.mapreduce.lib.input.TextInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.mapreduce.lib.output.SequenceFileOutputFormat;
import org.apache.hadoop.mapreduce.lib.output.TextOutputFormat;

public class UniqueWords {
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
                Text outputValue = new Text(word);
                context.write(outputValue, new IntWritable(1));
            }
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
     * WordLengthMap --- The class containing the WordCount mapper.
     */
    public static class WordLengthMap extends Mapper<Text, Text, Text, IntWritable> {
        /**
         * Perform whe WordCount mapping.
         */
		public void map(Text key, Text value, Context context) throws IOException, InterruptedException {
            String word = key.toString();
            value.set(String.valueOf(word.length()));
            context.write(value, new IntWritable(1));
        }
    }

    /**
     * WordLengthReduce --- Implement the WordCount reducer.
     */
	public static class WordLengthReduce extends Reducer<Text, IntWritable, Text, IntWritable> {
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
     * @param args The input argumments
     * @throws IOException
     * @throws InterruptedException
     * @throws ClassNotFoundException
     */
    public static void main(String[] args) throws IOException, ClassNotFoundException, InterruptedException {
        // set the job configuration
        Configuration conf = new Configuration();

        // create the first job
		Job wordFrequencyJob = Job.getInstance(conf);
		wordFrequencyJob.setJarByClass(WordCount.class);
		wordFrequencyJob.setJobName("WordCount_Frequency");

        // set the map and reducer classes
		wordFrequencyJob.setMapperClass(WordCountMap.class);
		wordFrequencyJob.setReducerClass(WordCountReduce.class);

        // set the output key and value classes
		wordFrequencyJob.setOutputKeyClass(Text.class);
		wordFrequencyJob.setOutputValueClass(IntWritable.class);

        // set the input and output format
		wordFrequencyJob.setInputFormatClass(TextInputFormat.class);
		wordFrequencyJob.setOutputFormatClass(TextOutputFormat.class);

        // set the paths to the input and output files
		FileInputFormat.addInputPath(wordFrequencyJob, new Path("/workspaces/adelaidex/big-data/bigdatax/java/section05/MapReduce/src/activity06/SecondInputFile.txt"));
		FileOutputFormat.setOutputPath(wordFrequencyJob, new Path("section05/MapReduce/src/activity06/output_02/"));

        /* --- create the second job --- */
		Job wordLengthJob = Job.getInstance(conf);
		wordLengthJob.setJarByClass(WordCount.class);
		wordLengthJob.setJobName("WordCount_Length");

        // set the map and reducer classes
		wordLengthJob.setMapperClass(WordLengthMap.class);
		wordLengthJob.setReducerClass(WordLengthReduce.class);

        // set the output key and value classes
		wordLengthJob.setOutputKeyClass(Text.class);
		wordLengthJob.setOutputValueClass(IntWritable.class);

        // set the input and output format
		wordLengthJob.setInputFormatClass(KeyValueTextInputFormat.class);
		wordLengthJob.setOutputFormatClass(TextOutputFormat.class);

        // set the paths to the input and output files
		FileInputFormat.addInputPath(wordLengthJob, new Path("section05/MapReduce/src/activity06/output_02/part-r-00000"));
		FileOutputFormat.setOutputPath(wordLengthJob, new Path("section05/MapReduce/src/activity06/output_03/"));
        
        // start the jobs and wait for it to complete
        wordFrequencyJob.waitForCompletion(true);
        wordLengthJob.waitForCompletion(true);
        System.exit(0);
    }    
}
