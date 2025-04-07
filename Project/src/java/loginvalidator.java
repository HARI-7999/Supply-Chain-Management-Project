/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.*;

/**
 *
 * @author user
 */
public class loginvalidator extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        String userid=request.getParameter("userid");
        String userpassword=request.getParameter("userpassword");
        HttpSession session=request.getSession();
        session.setAttribute("id",userid);
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3307/project_database","root","");  
            Statement st=con.createStatement();
            ResultSet rs=st.executeQuery("select * from login_details where user_id ='"+userid+"' ;");
            boolean none=true;
                
            
            while(rs.next())
            {
                if(userid.equals(rs.getString(1)) && userpassword.equals(rs.getString(2)))
                {
                    if(rs.getInt(3)==1)
                    {
                        response.sendRedirect("admin.jsp?#dashboard");
                        none=false;
                    }
                    else
                    {
                        if(rs.getInt(4)==0){
                            out.println("<script type='text/javascript'>");
                            out.println("alert(' Your Credentials are Not approved by ADMIN .');");
                            out.println("window.location.href = 'index.html';");
                            out.println("</script>");
                        }
                        else{
                        response.sendRedirect("user.jsp");
                    }
                        none=false;
                    }
                }
                else
                { 
                  
                    out.println("<script type='text/javascript'>");
                    out.println("alert(' Invalid credentials .');");
                    out.println("window.location.href = 'index.html';");
                    out.println("</script>");
                    none=false;
                }
            }
            if(none){
                out.println("<script type='text/javascript'>");
                    out.println("alert(' Invalid credentials .');");
                    out.println("window.location.href = 'index.html';");
                    out.println("</script>");
            }
            
            
        }
        catch(ClassNotFoundException ex)
        {
            out.println(" CLASS NOT FOUND EXCEPTION"+ex.getMessage());
        }
        catch(SQLException ex)
        {
            out.println(" CSQL EXCEPTION"+ex.getMessage());
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
