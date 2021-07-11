package section06;

public class State02 {
    public static void main(String[] args) {
        Person p = new Person("Bob", 30);
        System.out.println(p);
    }
}

class Person { 
	protected String name;
	protected int age;

	public Person(String n, int a){
		name = n;
		age = a;
	}
}

class Staff extends Person {
    public Staff(String n, int a) {
        super(n, a);
    }
}