package section09.activity13;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;

/**
 * Anagrams --- Read a dictionary of words and provide anagram functions.
 */
class Anagrams {
    private HashMap<String, ArrayList<String>> anagramDictionary;

    /**
     * Create a new instance of the class and load the dictionary into memory.
     * @param path The path to the dictionary to load.
     */
    public Anagrams(String path) {
        super();

        // load the dictionary for processing
        this.anagramDictionary = this.loadDictionary(path);
    }        

    /**
     * Load a dictionary from file and create an in memory anagram dictionary.
     * @param path The file path of the dictionary to load.
     * @return The anagram dictionary created from the file.
     */
    protected HashMap<String, ArrayList<String>> loadDictionary(String path) {
        HashMap<String, ArrayList<String>> dictionary = new HashMap<String, ArrayList<String>>();

        // read the input data file and build the dictionary
        File f = new File(path);
        try {
            Scanner sc = new Scanner(f);
            while( sc.hasNextLine() ) {
                String word = sc.nextLine();
                String sortedWord = this.sortCharacters(word);

                // add the word to the dictionary
                ArrayList<String> wordList = dictionary.get(sortedWord);
                if (wordList == null) wordList = new ArrayList<String>();
                
                wordList.add(word);
                dictionary.put(sortedWord, wordList);
            }
        } catch (FileNotFoundException ex) {
            System.out.println("File "+f+" not found.");
        }

        return dictionary;
    }

    /**
     * Alphabetically sort the characters in a string.
     * @param s The string to sort.
     * @return The string with the sorted characters.
     */
    public String sortCharacters( String s ) {
        char[] chArray = s.toCharArray();
        Arrays.sort(chArray);

        return new String(chArray);
    }

    /**
     * Get the number of keys in the anagram list.
     * @return The total number of anagram keys.
     */
    public int getSize() {
        return this.anagramDictionary.keySet().size();
    }

    /**
     * Determine if two words are anagrams of each other.
     * @param word1 The first word to compare.
     * @param word2 The second word.
     * @return Returns true if the words are anagrams, false otherwise.
     */
    public boolean isAnagram(String word1, String word2) {
        // the shortcut is this, but the activity ask to consult the hashmap
        //return (this.sortCharacters(word1).equals(word2));

        // get the dictionary entry
        String sortedWord = this.sortCharacters(word1);
        ArrayList<String> wordList = this.anagramDictionary.get(sortedWord);

        if (wordList == null)
            return false;
        else
            return wordList.contains(word2);
    }

    /**
     * Get the list of anagrams for a word.
     * @param word The word to find the angrams for.
     * @return The list of anagrams, including the original word.
     */
    public ArrayList<String> getAnagrams(String word) {
        String sortedWord = this.sortCharacters(word);
        return this.anagramDictionary.get(sortedWord);        
    }

    /**
     * Get the longest list of anagrams in the dictionary.
     * @return Returns the longest list of anagram words.
     */
    public ArrayList<String> getLongestList() {
        int longest = 0;
        ArrayList<String> longestList = null;

        for ( Map.Entry<String, ArrayList<String>> entry : this.anagramDictionary.entrySet() ) {
            ArrayList<String> currentList = entry.getValue();
            if (currentList.size() > longest) {
                longest = currentList.size();
                longestList = currentList;
            }
        }

        return longestList;
    }
}

/**
 * AnagramBuilder --- Activity 13
 */
public class AnagramBuilder {
    public static void main(String[] args) {
        Anagrams anagrams = new Anagrams("section09/activity13/words_alpha.txt");

        System.out.println("Anagram Keys              : " + anagrams.getSize());
        System.out.println("Is anagram (beard, bread) : " + anagrams.isAnagram("beard", "bread"));
        System.out.println("Anagrams for (search)     : " + anagrams.getAnagrams("search").size());
        System.out.println("Longest Anagram List      : " + anagrams.getLongestList().size());
    }
}
