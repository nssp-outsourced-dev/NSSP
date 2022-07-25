package kr.go.nssp.utl;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class SimpleUtils {
    public static String default_set(String str) {
        String rtn = "";
        try {
            if (str == null || str == "")
                return rtn;
            return str;
        } catch (Exception exception) {
            return rtn;
        }
    }

    public static boolean isStringInteger(String s) {
        try {
            Integer.parseInt(s);
            return true;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    public static boolean isStringDouble(String s) {
        try {
            Double.parseDouble(s);
            return true;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    public static String secondsToTime(double arg) {
        int hours = 0;
        int minutes = 0;
        double seconds = 0.0D;
        try {
            hours = (int)(arg / 3600.0D);
            minutes = (int)(arg % 3600.0D / 60.0D);
            seconds = arg % 3600.0D % 60.0D;
            return String.format("%02d:%02d:%02.2f", new Object[] { Integer.valueOf(hours), Integer.valueOf(minutes), Double.valueOf(seconds) });
        } catch (Exception e) {
            return "00:00:00";
        }
    }

    public static double timeToSeconds(String arg) {
        double duration = 0.0D;
        try {
            String[] time = arg.split(":");
            if (time.length == 3) {
                int hours = Integer.parseInt(time[0]);
                int minutes = Integer.parseInt(time[1]);
                double seconds = Double.parseDouble(time[2]);
                duration = (hours * 3600 + minutes * 60) + seconds;
            }
        } catch (Exception e) {
            return 0.0D;
        }
        return duration;
    }

    public static boolean regularExp(String arg, String regExp) {
        try {
            Pattern p = Pattern.compile(regExp);
            Matcher m = p.matcher(arg);
            return m.find();
        } catch (Exception e) {
            return false;
        }
    }

    public static String[] rangeToStringArray(int sInt, int eInt) {
        try {
            String[] sa = new String[eInt - sInt + 1];
            int p = 0;
            for (int i = sInt; i <= eInt; i++) {
                sa[p] = Integer.toString(i);
                p++;
            }
            return sa;
        } catch (Exception e) {
            return null;
        }
    }
}
