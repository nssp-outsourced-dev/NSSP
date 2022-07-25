package kr.go.nssp.utl;

import java.io.File;
import java.io.IOException;
import java.io.RandomAccessFile;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class StreamView {
    public void makeStream(String videoFilePath, HttpServletRequest request, HttpServletResponse response) throws Exception {
        RandomAccessFile randomFile = new RandomAccessFile(new File(videoFilePath), "r");
        long rangeStart = 0L;
        long rangeEnd = 0L;
        boolean isPart = false;
        try {
            long movieSize = randomFile.length();
            String range = request.getHeader("range");
            if (range != null) {
                if (range.endsWith("-"))
                    range = String.valueOf(range) + (movieSize - 1L);
                int idxm = range.trim().indexOf("-");
                rangeStart = Long.parseLong(range.substring(6, idxm));
                rangeEnd = Long.parseLong(range.substring(idxm + 1));
                if (rangeStart > 0L)
                    isPart = true;
            } else {
                rangeStart = 0L;
                rangeEnd = movieSize - 1L;
            }
            long partSize = rangeEnd - rangeStart + 1L;
            response.reset();
            response.setStatus(isPart ? 206 : 200);
            response.setContentType("video/x-flv");
            response.setHeader("Content-Range", "bytes " + rangeStart + "-" + rangeEnd + "/" + movieSize);
            response.setHeader("Accept-Ranges", "bytes");
            response.setHeader("Content-Length", "" + partSize);
            ServletOutputStream servletOutputStream = response.getOutputStream();
            randomFile.seek(rangeStart);
            int bufferSize = 8192;
            byte[] buf = new byte[bufferSize];
            do {
                int block = (partSize > bufferSize) ? bufferSize : (int)partSize;
                int len = randomFile.read(buf, 0, block);
                servletOutputStream.write(buf, 0, len);
                partSize -= block;
            } while (partSize > 0L);
        } catch (IOException iOException) {

        } finally {
            randomFile.close();
        }
    }
}
