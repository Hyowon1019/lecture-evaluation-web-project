package user;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import util.DatabaseUtil;

public class UserDAO {
	
	public int login(String userID, String userPW) {
		String SQL = "SELECT userPW FROM USER WHERE userID = ?;";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery(); // executeQuery는 select를 처리할때(rs이용)
			
			if(rs.next()){ // 위 SQL문 실행한 결과가 존재한다면
			    if(rs.getString(1).equals(userPW)) {
			        return 1; // 로그인성공
			    }else {
			        return 0; // 비밀번호 틀림
			    }
			    
			}
			
			return -1; //  아이디 없음
			
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}finally {
		    try {if (conn != null)conn.close();} catch (SQLException e) {e.printStackTrace();}
            try {if (pstmt != null)pstmt.close();} catch (SQLException e) {e.printStackTrace();}
            try {if (rs != null)rs.close();} catch (SQLException e) {e.printStackTrace();}
        }
		return -2; // 데이터베이스 오류
	}
	
	public int join(UserDTO user) {
	    String SQL = "INSERT INTO USER VALUES (?, ?, ?, ?, false);";
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    try {
	        conn = DatabaseUtil.getConnection();
	        pstmt = conn.prepareStatement(SQL);
	        pstmt.setString(1, user.getUserID());
	        pstmt.setString(2, user.getUserPW());
	        pstmt.setString(3, user.getUserEmail());
	        pstmt.setString(4, user.getUserEmailHash());
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
	    return -1; // 회원가입 실패
	}
	
	public String getUserEmail(String userID) {
	    String SQL = "SELECT userEmail FROM USER WHERE userID = ?;";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, userID);
            rs = pstmt.executeQuery();
            if(rs.next()) {
                return rs.getString(1);
            }
        } catch (Exception e) {
            // TODO: handle exception
            e.printStackTrace();
        } finally {
            try {if (conn != null)conn.close();} catch (SQLException e) {e.printStackTrace();}
            try {if (pstmt != null)pstmt.close();} catch (SQLException e) {e.printStackTrace();}
            try {if (rs != null)rs.close();} catch (SQLException e) {e.printStackTrace();}
        }
        return null; // 데이터베이스 오류
	}
	
	public boolean getUserEmailChecked(String userID) {
	    String SQL = "SELECT userEmailChecked FROM USER WHERE userID = ?;";
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    try {
	        conn = DatabaseUtil.getConnection();
	        pstmt = conn.prepareStatement(SQL);
	        pstmt.setString(1, userID);
	        rs = pstmt.executeQuery();
	        if(rs.next()) {
	            return rs.getBoolean(1);
	        }
	    } catch (Exception e) {
	        // TODO: handle exception
	        e.printStackTrace();
	    }finally {
	        try {if (conn != null)conn.close();} catch (SQLException e) {e.printStackTrace();}
            try {if (pstmt != null)pstmt.close();} catch (SQLException e) {e.printStackTrace();}
            try {if (rs != null)rs.close();} catch (SQLException e) {e.printStackTrace();}
	    }
	    return false; // 데이터베이스 오류
	}
	
	public boolean setUserEmailChecked(String userID) {
	    String SQL = "UPDATE USER SET userEmailChecked = true WHERE userID = ?;";
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    try {
	        conn = DatabaseUtil.getConnection();
	        pstmt = conn.prepareStatement(SQL);
	        pstmt.setString(1, userID);
	        pstmt.executeUpdate();
	        return true;
	    } catch (Exception e) {
	        // TODO: handle exception
	        e.printStackTrace();
	    }finally {
	        try {if (conn != null)conn.close();} catch (SQLException e) {e.printStackTrace();}
            try {if (pstmt != null)pstmt.close();} catch (SQLException e) {e.printStackTrace();}
            try {if (rs != null)rs.close();} catch (SQLException e) {e.printStackTrace();}
	    }
	    return false; // 데이터베이스 오류
	}
	
}
