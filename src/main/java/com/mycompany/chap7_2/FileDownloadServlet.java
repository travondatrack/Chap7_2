package com.mycompany.chap7_2;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class FileDownloadServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String productCode = request.getParameter("productCode");
        String fileName = request.getParameter("file");
        if (productCode == null || fileName == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        // build real path under webapp
        String realPath = getServletContext().getRealPath("/musicStore/sound/" + productCode + "/" + fileName);
        File file = new File(realPath);

        // If the requested file doesn't exist, try a .zip alternative (user compressed files into zips)
        boolean servingZip = false;
        if (!file.exists() || !file.isFile()) {
            String altName = null;
            if (fileName.toLowerCase().endsWith(".mp3")) {
                altName = fileName.substring(0, fileName.length() - 4) + ".zip";
            } else {
                altName = fileName + ".zip";
            }
            String altPath = getServletContext().getRealPath("/musicStore/sound/" + productCode + "/" + altName);
            File altFile = new File(altPath);
            if (altFile.exists() && altFile.isFile()) {
                file = altFile;
                fileName = altName;
                servingZip = true;
            }
        }

        if (!file.exists() || !file.isFile()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // set content type according to extension
        String lc = file.getName().toLowerCase();
        if (lc.endsWith(".zip")) {
            response.setContentType("application/zip");
        } else if (lc.endsWith(".mp3")) {
            response.setContentType("audio/mpeg");
        } else {
            response.setContentType("application/octet-stream");
        }

        response.setContentLengthLong(file.length());
        // force download
        response.setHeader("Content-Disposition", "attachment; filename=\"" + file.getName() + "\"");

        try (BufferedInputStream in = new BufferedInputStream(new FileInputStream(file));
             OutputStream out = response.getOutputStream()) {
            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        }
    }
}
