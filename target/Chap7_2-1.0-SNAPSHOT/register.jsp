<%@page contentType="text/html" pageEncoding="UTF-8"%> <%@page
import="java.util.*"%>
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>Download Registration</title>
    <style>
      body {
        font-family: Arial, sans-serif;
        margin: 40px;
      }
      .container {
        max-width: 500px;
        margin: 0 auto;
      }
      h1 {
        color: #0066cc;
        margin-bottom: 20px;
      }
      .form-group {
        margin-bottom: 15px;
      }
      label {
        display: block;
        margin-bottom: 5px;
        font-weight: bold;
      }
      input[type="text"],
      input[type="email"] {
        width: 100%;
        padding: 8px;
        border: 1px solid #ccc;
        border-radius: 4px;
        box-sizing: border-box;
      }
      button {
        background-color: #0066cc;
        color: white;
        padding: 10px 20px;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        font-size: 16px;
      }
      button:hover {
        background-color: #0052a3;
      }
      .error {
        color: red;
        margin-bottom: 15px;
      }
      .description {
        margin-bottom: 20px;
        color: #666;
      }
    </style>
  </head>
  <body>
    <div class="container">
      <h1>Download registration</h1>

      <p class="description">
        To register for our downloads, enter your name and email address below.
        Then, click on the Submit button.
      </p>

      <% String errorMsg = (String) request.getAttribute("error"); if (errorMsg
      != null) { %>
      <div class="error"><%= errorMsg %></div>
      <% } %>

      <form method="post" action="download">
        <% String productCode = (String) request.getAttribute("productCode"); if
        (productCode == null) productCode = ""; %>
        <input type="hidden" name="action" value="registerUser" />
        <input type="hidden" name="productCode" value="<%= productCode %>" />

        <div class="form-group">
          <label for="email">Email:</label>
          <% String email = request.getParameter("email"); if (email == null)
          email = ""; %>
          <input
            type="email"
            id="email"
            name="email"
            required
            value="<%= email %>"
          />
        </div>

        <div class="form-group">
          <label for="firstName">First Name:</label>
          <% String firstName = request.getParameter("firstName"); if (firstName
          == null) firstName = ""; %>
          <input
            type="text"
            id="firstName"
            name="firstName"
            required
            value="<%= firstName %>"
          />
        </div>

        <div class="form-group">
          <label for="lastName">Last Name:</label>
          <% String lastName = request.getParameter("lastName"); if (lastName ==
          null) lastName = ""; %>
          <input
            type="text"
            id="lastName"
            name="lastName"
            required
            value="<%= lastName %>"
          />
        </div>

        <button type="submit">Register</button>
      </form>
    </div>
  </body>
</html>
