package section06;

import java.util.Calendar;

public class JavaAPI03 {

    public static int rand10() {
	    return (int) (Math.random() * 10.0) + 1;
    }
    public static void main(String[] args) {
        // use the calander
        Calendar now = Calendar.getInstance();
        System.out.println(now.getTime());

        // generate a random number in [1..10]
        System.out.println( (int) (Math.random() * 10.0) + 1 );
        System.out.println( rand10() );
    }
}
