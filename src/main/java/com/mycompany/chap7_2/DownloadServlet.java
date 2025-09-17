package com.mycompany.chap7_2;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import murach.business.User;
import murach.data.UserIO;
import murach.util.CookieUtil;

public class DownloadServlet extends HttpServlet {

    // Album data: productCode -> list of songs (title, format, file)
    private static final Map<String, List<Map<String, String>>> ALBUMS = new HashMap<>();
    private static final Map<String, String> ALBUM_TITLES = new HashMap<>();

    static {
        // HIEUTHUHAI (hieuthuhai2023)
        ALBUM_TITLES.put("hieuthuhai2023", "Ai Cũng Phải Bắt Đầu Từ Đâu Đó – HIEUTHUHAI (2023)");
    List<Map<String, String>> list1 = new ArrayList<>();
    Map<String,String> s1 = new HashMap<>(); s1.put("title","Exit Sign"); s1.put("format","MP3"); s1.put("file","Music.mp3"); list1.add(s1);
    Map<String,String> s2 = new HashMap<>(); s2.put("title","NOLOVENOLIFE"); s2.put("format","MP3"); s2.put("file","Music.mp3"); list1.add(s2);
    ALBUMS.put("hieuthuhai2023", list1);

        // SZA (sza2022)
        ALBUM_TITLES.put("sza2022", "SOS – SZA (2022)");
    List<Map<String, String>> list2 = new ArrayList<>();
    Map<String,String> s3 = new HashMap<>(); s3.put("title","Kill Bill"); s3.put("format","MP3"); s3.put("file","Music.mp3"); list2.add(s3);
    Map<String,String> s4 = new HashMap<>(); s4.put("title","Saturn"); s4.put("format","MP3"); s4.put("file","Music.mp3"); list2.add(s4);
    ALBUMS.put("sza2022", list2);

        // Harry Styles (harrystyles2022)
        ALBUM_TITLES.put("harrystyles2022", "Harry's House – Harry Styles (2022)");
    List<Map<String, String>> list3 = new ArrayList<>();
    Map<String,String> s5 = new HashMap<>(); s5.put("title","As It Was"); s5.put("format","MP3"); s5.put("file","Music.mp3"); list3.add(s5);
    Map<String,String> s6 = new HashMap<>(); s6.put("title","Late Night Talking"); s6.put("format","MP3"); s6.put("file","Music.mp3"); list3.add(s6);
    ALBUMS.put("harrystyles2022", list3);

        // Maroon 5 (maroon52012)
        ALBUM_TITLES.put("maroon52012", "Overexposed – Maroon 5 (2012)");
    List<Map<String, String>> list4 = new ArrayList<>();
    Map<String,String> s7 = new HashMap<>(); s7.put("title","Payphone"); s7.put("format","MP3"); s7.put("file","Music.mp3"); list4.add(s7);
    Map<String,String> s8 = new HashMap<>(); s8.put("title","One More Night"); s8.put("format","MP3"); s8.put("file","Music.mp3"); list4.add(s8);
    ALBUMS.put("maroon52012", list4);
    }

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
        throws IOException, ServletException {

        // get current action
        String action = request.getParameter("action");
        if (action == null) {
            action = "viewAlbums"; // default action
        }

        // perform action and set URL to appropriate page
        String url = "/index.html";
        if (action.equals("viewAlbums")) {
            url = "/index.html";
        } else if (action.equals("checkUser")) {
            url = checkUser(request, response);
        }
        // if a productCode was passed directly and action not checkUser, allow direct access
        String productCode = request.getParameter("productCode");
        HttpSession session = request.getSession(false);
        if (productCode != null && session != null && session.getAttribute("user") != null) {
            // user already registered, show download page
            request.setAttribute("productCode", productCode);
            request.setAttribute("songs", ALBUMS.get(productCode));
            request.setAttribute("albumTitle", ALBUM_TITLES.get(productCode));
            url = "/download.jsp";
        }

        // forward to the view
        getServletContext()
                .getRequestDispatcher(url)
                .forward(request, response);
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response)
        throws IOException, ServletException {

        String action = request.getParameter("action");

        // perform action and set URL to appropriate page
        String url = "/index.html";
        if (action != null && action.equals("registerUser")) {
            url = registerUser(request, response);
        }

        // forward to the view
        getServletContext()
                .getRequestDispatcher(url)
                .forward(request, response);
    }

    private String checkUser(HttpServletRequest request, HttpServletResponse response) {
        String productCode = request.getParameter("productCode");
    // reference response to avoid unused parameter warnings
    response.hashCode();
        HttpSession session = request.getSession();
        session.setAttribute("productCode", productCode);
        User user = (User) session.getAttribute("user");

        String url;
        // if User object doesn't exist, check email cookie
        if (user == null) {
            Cookie[] cookies = request.getCookies();
            String emailAddress = CookieUtil.getCookieValue(cookies, "emailCookie");

            // if cookie doesn't exist, go to Registration page
            if (emailAddress == null || emailAddress.equals("")) {
                url = "/register.jsp";
            }
            // if cookie exists, create User object and go to Downloads page
            else {
                ServletContext sc = getServletContext();
                String path = sc.getRealPath("/WEB-INF/EmailList.txt");
                try {
                    user = UserIO.getUser(emailAddress, path);
                    session.setAttribute("user", user);
                    // set songs and title attributes and go to download.jsp
                    request.setAttribute("productCode", productCode);
                    request.setAttribute("songs", ALBUMS.get(productCode));
                    request.setAttribute("albumTitle", ALBUM_TITLES.get(productCode));
                    url = "/download.jsp";
                } catch (IOException e) {
                    // if reading fails, go to registration page
                    url = "/register.jsp";
                }
            }
        }
        // if User object exists, go to Downloads page
        else {
            request.setAttribute("productCode", productCode);
            request.setAttribute("songs", ALBUMS.get(productCode));
            request.setAttribute("albumTitle", ALBUM_TITLES.get(productCode));
            url = "/download.jsp";
        }
        return url;
    }

    private String registerUser(HttpServletRequest request, HttpServletResponse response) {

        // get the user data
        String email = request.getParameter("email");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");

        // store the data in a User object
        User user = new User();
        user.setEmail(email);
        user.setFirstName(firstName);
        user.setLastName(lastName);

        // write the User object to a file
        ServletContext sc = getServletContext();
        String path = sc.getRealPath("/WEB-INF/EmailList.txt");
        try {
            UserIO.add(user, path);
        } catch (IOException e) {
            // ignore write failure for now; could log
        }

        // store the User object as a session attribute
        HttpSession session = request.getSession();
        session.setAttribute("user", user);

        // add a cookie that stores the user's email to browser
        Cookie c = new Cookie("emailCookie", email);
        c.setMaxAge(60 * 60 * 24 * 365 * 2); // set age to 2 years
        c.setPath("/"); // allow entire app to access it
        response.addCookie(c);

        // create and return a URL for the appropriate Download page
        String productCode = (String) session.getAttribute("productCode");
        if (productCode != null && ALBUMS.containsKey(productCode)) {
            request.setAttribute("productCode", productCode);
            request.setAttribute("songs", ALBUMS.get(productCode));
            request.setAttribute("albumTitle", ALBUM_TITLES.get(productCode));
            return "/download.jsp";
        } else {
            // product code missing or invalid, go back to index
            return "/index.jsp";
        }
    }
}