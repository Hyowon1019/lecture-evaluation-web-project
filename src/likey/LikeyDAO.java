package likey;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import util.DatabaseUtil;

public class LikeyDAO {
    
    public int like(String userID, String evaluationID, String userIP) {
        String SQL = "INSERT INTO LIKEY VALUES (?, ?, ?);";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, userID);
            pstmt.setString(2, evaluationID);
            pstmt.setString(3, userIP);
            return pstmt.executeUpdate(); // executeUpdate는 insert delete update 등을 처리할때
            // 업뎃된 DB 계수를 반환하므로 1반환이면 회원가입 성공 -1반환이면 DB오류 or 회원가입 실패.
        } catch (Exception e) {
            // TODO: handle exception
            e.printStackTrace();
        }finally {
            try {if (conn != null)conn.close();} catch (SQLException e) {e.printStackTrace();}
            try {if (pstmt != null)pstmt.close();} catch (SQLException e) {e.printStackTrace();}
            try {if (rs != null)rs.close();} catch (SQLException e) {e.printStackTrace();}
        }
        return -1; // 추천 중복 오류
    }

}
