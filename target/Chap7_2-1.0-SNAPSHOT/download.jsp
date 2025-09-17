<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Downloads</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 40px;
            }
            .container {
                max-width: 600px;
                margin: 0 auto;
            }
            h1 {
                color: #008080;
                margin-bottom: 20px;
            }
            h2 {
                color: #008080;
                margin-bottom: 15px;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
            }
            th, td {
                border: 1px solid #ccc;
                padding: 10px;
                text-align: left;
            }
            th {
                background-color: #f5f5f5;
                font-weight: bold;
            }
            .mp3-link {
                color: #0066cc;
                text-decoration: underline;
                cursor: pointer;
            }
            .mp3-link:hover {
                color: #0052a3;
            }
            .back-link {
                display: inline-block;
                margin-top: 20px;
                color: #0066cc;
                text-decoration: none;
            }
            .back-link:hover {
                text-decoration: underline;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>Downloads</h1>
            
            <% 
                String albumTitle = (String) request.getAttribute("albumTitle");
                String productCode = (String) request.getAttribute("productCode");
                if (albumTitle != null) {
            %>
            <h2><%= albumTitle %></h2>
            <% } %>
            <% if (productCode != null) { %>
                <p>
                    <a class="mp3-link" href="downloadFile?productCode=<%= productCode %>&amp;file=Music.mp3">Download album (Music.mp3)</a>
                </p>
            <% } %>
            
            <table>
                <tr>
                    <th>Song title</th>
                    <th>Audio Format</th>
                </tr>
                <%
                    @SuppressWarnings("unchecked")
                    List<Map<String, String>> songs = (List<Map<String, String>>) request.getAttribute("songs");
                    if (songs != null) {
                        for (Map<String, String> song : songs) {
                %>
                    <tr>
                        <td><%= song.get("title") %></td>
                        <td>
                            <a class="mp3-link" href="downloadFile?productCode=<%= request.getAttribute("productCode") %>&amp;file=Music.mp3">
                                Download (MP3)
                            </a>
                        </td>
                    </tr>
                <%
                        }
                    }
                %>
            </table>
            
            <a href="index.html" class="back-link">← Back to Albums</a>
        </div>
    </body>
</html>