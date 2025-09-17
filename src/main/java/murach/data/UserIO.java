package murach.data;

import java.io.*;
import java.util.*;
import murach.business.User;

public class UserIO {
    
    public static void add(User user, String filepath) throws IOException {
        File file = new File(filepath);
        PrintWriter out = new PrintWriter(
                            new FileWriter(file, true));
        
        out.println(user.getEmail() + "|" 
                  + user.getFirstName() + "|"
                  + user.getLastName());
        out.close();
    }
    
    public static User getUser(String emailAddress, String filepath) throws IOException {
        File file = new File(filepath);
        if (!file.exists()) {
            return null;
        }
        
        BufferedReader in = new BufferedReader(
                            new FileReader(file));
        
        User user = null;
        String line = in.readLine();
        while (line != null) {
            StringTokenizer t = new StringTokenizer(line, "|");
            String email = t.nextToken();
            if (email.equalsIgnoreCase(emailAddress)) {
                String firstName = t.nextToken();
                String lastName = t.nextToken();
                user = new User(firstName, lastName, email);
                break;
            }
            line = in.readLine();
        }
        in.close();
        
        return user;
    }
    
    public static ArrayList<User> getUsers(String filepath) throws IOException {
        ArrayList<User> users = new ArrayList<User>();
        File file = new File(filepath);
        if (!file.exists()) {
            return users;
        }
        
        BufferedReader in = new BufferedReader(
                            new FileReader(file));
        
        String line = in.readLine();
        while (line != null) {
            StringTokenizer t = new StringTokenizer(line, "|");
            String email = t.nextToken();
            String firstName = t.nextToken();
            String lastName = t.nextToken();
            User user = new User(firstName, lastName, email);
            users.add(user);
            line = in.readLine();
        }
        in.close();
        
        return users;
    }
}