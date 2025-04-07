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
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.ResultSet;

/**
 *
 * @author user
 */
public class userservletpack extends HttpServlet {

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
        
        HttpSession  session = request.getSession(true);
        String userid=(String) session.getAttribute("id");
        
        try {
            /* TODO output your page here. You may use following sample code. */
            Class.forName("com.mysql.jdbc.Driver");
            Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3307/project_database","root","");  
            Statement st=con.createStatement();
            String action=request.getParameter("action");
            
            switch(action)
            {
                case "order" ->{
                    String pr_id=request.getParameter("pr_id");
                    String pr_name=request.getParameter("pr_name");
                    String pr_pri=request.getParameter("pr_pri");
                    String pr_qty=request.getParameter("alt_qty");
                    st.executeUpdate("insert into orders ( order_day,userid, product_id, product_name, price, qty, total_value, in_transit, received) values(curdate(),'"+userid+"','"+pr_id+"','"+pr_name+"',"+pr_pri+", "+pr_qty+",null,0,0);");
                    
                    out.println("<script type='text/javascript'>");
                    out.println("alert('Stock order palaced successfully');");
                    out.println("window.location.href = 'user.jsp?#orderstock';");
                    out.println("</script>");
                }
                case "orderreceivedupdate" ->{
                String orderid=request.getParameter("orderid");
                String productid=request.getParameter("pro_id");
                String orderqty=request.getParameter("or_qty") ;
                String price=request.getParameter("price");
                
                ResultSet list=st.executeQuery("select * from "+userid+"_stock_list where product_id='"+productid+"' ;" );
                if(list.next()){
                st.executeUpdate("update "+userid+"_stock_list set price="+price+" , qty=qty+"+orderqty+" where product_id= '"+productid+"' ;");
                st.executeUpdate("update orders set received=1 where order_id="+orderid+" ;");
                }
                else{
                    ResultSet adlist=st.executeQuery("select * from admin_stock_list where product_id='"+productid+"' ;");
                    if(adlist.next()){
                    st.executeUpdate("Insert into "+userid+"_stock_list (product_id,product_name,qty,price) values('"+adlist.getString(1)+"','"+adlist.getString(2)+"',"+orderqty+","+adlist.getInt(4)+" );");
                    }
                    st.executeUpdate("update orders set received=1 where order_id="+orderid+" ;");
                    }
                out.println("<script type='text/javascript'>");
                out.println("alert('Order Received and successfully updated to stock list');");
                out.println("window.location.href = 'user.jsp?#stocklist';");
                out.println("</script>");
                    
                
                }
                case "bill_add_product" ->{
                    
                    String billno=request.getParameter("bill_no");
                    String customername=request.getParameter("customer_name");
                    String pr_id=request.getParameter("pro_details");
                    String pr_name=request.getParameter("Pro_name");
                    String price=request.getParameter("Pro_value");
                    String qty=request.getParameter("qty");
                    int qtty=Integer.parseInt(request.getParameter("qty"));
                    ResultSet check=st.executeQuery("select * from "+userid+"_stock_list where product_id='"+pr_id+"' ;");
                    if(check.next()){
                        if(qtty <= check.getInt(3)){
                    
                    st.executeUpdate("INSERT INTO "+userid+"_sales \n" +
                    "(bill_no, sale_date, customer_name, product_id, product_name, qty, price, sales) \n" +
                    "VALUES ( "+billno+" ,curdate() , '"+customername+"' , '"+pr_id+"' , '"+pr_name+"' ,"+qty+" ,"+price+", 0 );");
                    out.println("<script type='text/javascript'>");
                    out.println("window.location.href = 'user.jsp?#billing';");

                    out.println("</script>");
                        }
                    
                    else{
                        out.println("<script type='text/javascript'>");
                        out.println("alert('Insufficient stock ');");
                        
                        out.println("window.location.href = 'user.jsp?#billing';");
                        out.println("</script>");
                    }
                    }
                }
                case "bill_complete" ->{
                    Statement stt=con.createStatement();
                    ResultSet sale=st.executeQuery("select * from "+userid+"_sales where sales=0;");
                    while(sale.next()){
                        stt.executeUpdate("update "+userid+"_stock_list set qty=qty-"+sale.getInt(6)+" where product_id='"+sale.getString(4)+"' ;");
                    }
                    
                    
                    st.executeUpdate("update "+userid+"_sales set sales=1;");
                    out.println("<script type='text/javascript'>");    
                    out.println("window.location.href = 'user.jsp?#billing';");
                    out.println("</script>");
                }
                case "bill_reset" ->{
                    st.executeUpdate("delete from "+userid+"_sales where sales=0 ;");
                    out.println("<script type='text/javascript'>");    
                    out.println("window.location.href = 'user.jsp?#billing';");
                    out.println("</script>");
                }
            }
        }
        catch(ClassNotFoundException ex)
        {
            out.println("CLASS NOT FOUND EXCEPTION"+ex.getMessage());
        }
        catch(SQLException ex)
        {
            out.println("SQL EXCEPTION"+ex.getMessage());
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
