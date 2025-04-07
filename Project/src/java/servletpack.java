/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

import com.mysql.jdbc.ResultSet;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;


/**
 *
 * @author user
 */
public class servletpack extends HttpServlet {

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
        String action=request.getParameter("action");
        try{
            Class.forName("com.mysql.jdbc.Driver");
        Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3307/project_database","root","");  
        Statement st=con.createStatement();
        
        switch (action){
            case "productremove" -> {
                String id=request.getParameter("id");
                st.executeUpdate("delete from admin_stock_list where product_id = '"+id+"' ;");
                
                out.println("<script type='text/javascript'>");
                out.println("alert(' Prouduct removed successfully');");  
                out.println("window.location.href = 'admin.jsp?#removeproduct';"); 
                out.println("</script>");
                }
            case "productalter" -> {
               String id=request.getParameter("id");
               
               String price=request.getParameter("alt_price");
               String newprice=request.getParameter("alt_qty_add");
               st.executeUpdate("update admin_stock_list set qty= qty+"+newprice+" , price= "+price+" where product_id='"+id+"' ;");
               
               out.println("<script type='text/javascript'>");
                out.println("alert(' Prouduct details altered successfully');");  
                out.println("window.location.href = 'admin.jsp?#alterproduct';"); 
                out.println("</script>");
                }
            case "useradd" -> {
                String id=request.getParameter("addid");
                st.executeUpdate("update profile_details set Approval=1 where userid='"+id+"' ;");
                st.executeUpdate("update login_details set Approval=1 where user_id='"+id+"' ;");
                st.executeUpdate("create table "+id+"_stock_list(product_id varchar(10),product_name varchar(20),qty int,price int,total_value int as(price*qty) );");
                st.executeUpdate("create table "+id+"_sales (bill_no int primary key,sale_date date,customer_name varchar(30),product_id varchar(10),product_name varchar(20),qty int,price int,total_value int as(price*qty),sales int); ");
                out.println("<script type='text/javascript'>");
                out.println("alert('Successfully  New user :"+id+" added to the database');");  
                out.println("window.location.href = 'admin.jsp?#userlist';"); 
                out.println("</script>");
            }
            case "dealerremove" -> {
                String id=request.getParameter("id");
                st.executeUpdate("delete from profile_details where userid='"+id+"' ;");
                st.executeUpdate("delete from login_details where user_id='"+id+"' ;");
                st.executeUpdate("drop table "+id+"_stock_list ;");
                st.executeUpdate("drop table "+id+"_sales ;");
                out.println("<script type='text/javascript'>");
                out.println("alert('Successfully  user :"+id+" detailes removed from the database ');");  
                out.println("window.location.href = 'admin.jsp?#userlist';"); 
                out.println("</script>");
            }
            case "registeruser" -> {
                String userid=request.getParameter("userid");
                ResultSet list=(ResultSet) st.executeQuery("select * from login_details where user_id='"+userid+"' ;");
                if(list.next()){
                out.println("<script type='text/javascript'>");
                out.println("alert(' USER ID IS EXIST . Please enter any other userid ');");  
                out.println("window.location.href = 'index.html';"); 
                out.println("</script>");
                }
                else{
                    String name=request.getParameter("name");
                    String location=request.getParameter("location");
                    String mobile=request.getParameter("Mobile_no");
                    String email=request.getParameter("email");
                    String password=request.getParameter("password");
                    st.executeUpdate("Insert into login_details values('"+userid+"' ,'"+password+"' ,2,0);");
                    st.executeUpdate("Insert into profile_details values('"+userid+"','"+name+"','"+location+"','"+mobile+"','"+email+"','"+password+"',0 );");
                    out.println("<script type='text/javascript'>");
                    out.println("alert(' New User details are added to the Database . Admin need to approve the new user to login ');");  
                    out.println("window.location.href = 'index.html';"); 
                    out.println("</script>");
                }
            }
            case "ordertransfer" ->{
                String orderid=request.getParameter("orderid");
                String productid=request.getParameter("pro_id");
                int orderqty=Integer.parseInt(request.getParameter("or_qty")) ;
                ResultSet stock= (ResultSet) st.executeQuery("select * from admin_stock_list where product_id='"+productid+"' ;");
                if(stock.next())
                {
                int remainingqty=stock.getInt(3)-orderqty;
                
                    if(remainingqty > 0){
                st.executeUpdate("update orders set in_transit=1 where order_id="+orderid+" ;");
                st.executeUpdate("update admin_stock_list set qty="+remainingqty+" where product_id= '"+productid+"' ;");
                out.println("<script type='text/javascript'>");
                out.println("window.location.href = 'admin.jsp?#ordersview';");
                out.println("</script>");
                    }
                    else{
                        
                        out.println("<script type='text/javascript'>");
                        out.println("alert(' INSUFFICIENT STOCK ');");
                        out.println("window.location.href = 'admin.jsp?#ordersview';");
                        out.println("</script>");
                        
                    }
                }
            }
            default -> {
                out.println("<script type='text/javascript'>");
                out.println("alert('Someting wrong with the server');");  
                out.println("window.location.href = 'admin.jsp';"); 
                out.println("</script>");
                }
                
        }
        
        }
          catch(ClassNotFoundException ex)
                {
                out.println("CLASS NOT FOUND EXCEPTION Error : "+ex.getMessage());
                } 
        catch(SQLException ex)
        {
            out.println("SQL EXCEPTION Error : "+ex.getMessage());
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
