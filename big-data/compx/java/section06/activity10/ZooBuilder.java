/**
 * Activity 10 --- Coding a zoo.
 * @author         Johannes Foulds
 */
package section06.activity10;

import java.util.ArrayList;

import jdk.tools.jlink.resources.plugins;

/**
 * Animal --- This is the base class other animals will inherit from.
 */
class Animal {
    String name;
    String species;
    int age;

    /**
     * Default class constructor.
     */
    public Animal() {
        this("Animal", "None", 0);
    }

    /**
     * Construct a new animal class with specific attibutes.
     * 
     * @param name    The animal name.
     * @param species The species the animal belongs to.
     * @param age     The age of the animal.
     */
    public Animal(String name, String species, int age) {
        this.name = name;
        this.species = species;
        this.age = age;
    }

    /**
     * Output the details of the animal -- name, species, age.
     */
    public void printInfo() {
        System.out.println(String.format("%s, %s, %d", 
            this.name,
            this.species,
            this.age
        ));
    }
}

/**
 * Panda --- This class represents a panda in a zoo.
 */
class Panda extends Animal {
    /**
     * Set the default name and species.
     */
    public Panda() {
        super("Spot", "Ailuropoda melanoleuca", 0);
    }

    /**
     * Create a panda with a specific name and age.
     * 
     * @param name The animal name.
     * @param age  The age of the animal.
     */
    public Panda(String name, int age) {
        this();
        this.name = name;
        this.age = age;
    }
}

/**
 * Elephant --- This class represents an elephant in a zoo.
 */
class Elephant extends Animal {
    /**
     * Set the default name and species.
     */
    public Elephant() {
        super("Elle", "Loxodonta africana", 0);
    }

    /**
     * Create an elephant with a specific name and age.
     * 
     * @param name The animal name.
     * @param age  The age of the animal.
     */
    public Elephant(String name, int age) {
        this();
        this.name = name;
        this.age = age;
    }
}

/**
 * Lion --- This class represents a lion in a zoo.
 */
class Lion extends Animal {
    /**
     * Set the default name and species.
     */
    public Lion() {
        super("Alex", "Panthera leo", 0);
    }

    /**
     * Create a lion with a specific name and age.
     * 
     * @param name The animal name.
     * @param age  The age of the animal.
     */
    public Lion(String name, int age) {
        this();
        this.name = name;
        this.age = age;
    }

}

/**
 * Springbok --- This class represents a springbok in a zoo.
 */
class Springbok extends Animal {
    /**
     * Set the default name and species.
     */
    public Springbok() {
        super("Francois Pienaar", "Antidorcas marsupialis", 0);
    }

    /**
     * Create a springbok with a specific name and age.
     * 
     * @param name The animal name.
     * @param age  The age of the animal.
     */
    public Springbok(String name, int age) {
        this();
        this.name = name;
        this.age = age;
    }
}

/**
 * Zebra --- This class represents a zebra in a zoo.
 */
class Zebra extends Animal {
    /**
     * Set the default name and species.
     */
    public Zebra() {
        super("Marty", "Equus quagga", 0);
    }

    /**
     * Create a zebra with a specific name and age.
     * 
     * @param name The animal name.
     * @param age  The age of the animal.
     */
    public Zebra(String name, int age) {
        this();
        this.name = name;
        this.age = age;
    }
}

/**
 * Zoo --- This class represents a zoo with various animals. PLEASE NOTE: had to
 * remove the public type - ERROR: The public type Zoo must be defined in its
 * own fileJava(16777541)
 */
class Zoo {
    private ArrayList<Animal> animals;

    /**
     * Default class constructor.
     */
    public Zoo() {
        // create the list to hold animals in the zoo
        this.animals = new ArrayList<Animal>();
    }

    /**
     * Add a new animal to the zoo.
     * 
     * @param a The animal to add -- poor creature :'-(.
     */
    public void addAnimal(Animal a) {
        this.animals.add(a);
    }

    /**
     * Print the information of the animals in the zoo.
     */
    public void printAllInfo() {
        for (Animal animal : this.animals) {
            animal.printInfo();
        }
    }
}

/**
 * ZooBuilder --- The main class for the zoo implementation for buiding the zoo.
 */
public class ZooBuilder {
    public static void main(String[] args) {
        // create the zoo object
        Zoo zoo = new Zoo();

        // add animals to the zoo
        zoo.addAnimal(new Panda("Po", 24));
        zoo.addAnimal(new Panda("Bao", 18));
        zoo.addAnimal(new Elephant("Old Foot", 100));
        zoo.addAnimal(new Zebra());
        zoo.addAnimal(new Springbok("Francois", 54));

        // print the information of the animals in the zoo
        zoo.printAllInfo();
    }
}
