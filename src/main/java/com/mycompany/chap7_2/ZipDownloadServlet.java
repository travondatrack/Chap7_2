package com.mycompany.chap7_2;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ZipDownloadServlet extends HttpServlet {

    private static final int BUFFER_SIZE = 4096;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String productCode = request.getParameter("productCode");
        if (productCode == null || productCode.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing productCode");
            return;
        }

        String webappPath = request.getServletContext().getRealPath("/");
        File albumDir = new File(webappPath, "musicStore" + File.separator + "sound" + File.separator + productCode);
        if (!albumDir.exists() || !albumDir.isDirectory()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Album not found");
            return;
        }

        // Prepare response headers
        String zipName = productCode + ".zip";
        String encoded = URLEncoder.encode(zipName, "UTF-8").replaceAll("\\+", "%20");
        response.setContentType("application/zip");
        response.setHeader("Content-Disposition", "attachment; filename*=UTF-8''" + encoded);

        try (ZipOutputStream zos = new ZipOutputStream(response.getOutputStream())) {
            File[] files = albumDir.listFiles((dir, name) -> name.toLowerCase().endsWith(".mp3"));
            if (files == null || files.length == 0) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "No audio files found for album");
                return;
            }

            byte[] buffer = new byte[BUFFER_SIZE];
            for (File file : files) {
                ZipEntry entry = new ZipEntry(file.getName());
                entry.setSize(file.length());
                zos.putNextEntry(entry);

                try (FileInputStream fis = new FileInputStream(file)) {
                    int len;
                    while ((len = fis.read(buffer)) > 0) {
                        zos.write(buffer, 0, len);
                    }
                }

                zos.closeEntry();
            }
            zos.finish();
        } catch (IOException ex) {
            // If client cancels the download the write may fail — log and abort
            throw new ServletException("Error streaming ZIP", ex);
        }
    }
}
