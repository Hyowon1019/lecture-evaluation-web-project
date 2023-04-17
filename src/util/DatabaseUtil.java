package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DatabaseUtil {
	
	public static Connection getConnection() {
		try {
			String dbURL = "jdbc:mysql://localhost:3306/LectureEvaluation";
			String dbID = "root";
			String dbPW = "0000";
			Class.forName("com.mysql.jdbc.Driver");
			return DriverManager.getConnection(dbURL, dbID, dbPW);
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return null;
	}

}
