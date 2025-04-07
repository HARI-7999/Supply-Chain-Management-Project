<%-- 
    Document   : user
    Created on : 24-Mar-2025, 10:22:12 pm
    Author     : user
--%>

<%@page contentType="text/html" pageEncoding="UTF-8" import="java.sql.*;"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Supply chain management</title>
        <link rel="icon" href="images/logo.jpg">
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="css.css" rel="stylesheet" >
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </head>
    <body style="background-color: #F2F2F2;">
        <% String userid=(String) session.getAttribute("id"); %>
        <% 
            Class.forName("com.mysql.jdbc.Driver");
            Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3307/project_database","root","");  
            Statement st=con.createStatement();
        %>
        <nav class="navbar" style="background-color: #69cad1; border-bottom:  2px solid #000;">
            <div class="container-fluid d-flex justify-content-between align-items-center">
                <a class="navbar-brand" href="">
                    <img src="images/logo.jpg" width="30" height="30" />
                    Supply chain Management </a>
                <div class="dropdown">
                    <button class="btn btn-light dropdown-toggle d-flex align-items-center" type="button" id="userDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                        <img src="images/login.jpg" width="30" height="30" class="rounded-circle me-1" alt="User Icon">
                        <span class="fw-bold"><%=userid %></span>
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                        <li><a class="dropdown-item" href="#profiledetails">Profile</a></li>
                        <li><a class="dropdown-item" href="index.html">Logout</a></li>
                    </ul>
                </div>
            </div>
        </nav>

        <div class="d-flex">
            <div class="d-flex flex-column p-3" style="width: 18%; height: 100vh; background-color: #69cad1; border-right: 2px solid #000;">
                <a class="btn btn-light mb-3 p-3" href="#stocklist" >Stock List</a>
                <a class="btn btn-light mb-3 p-3" href="#billing">Billing</a>
                <a class="btn btn-light mb-3 p-3" href="#orderstock">Order Stock</a>
                <a class="btn btn-light mb-3 p-3" href="#stockintransit"> Intransit Stock </a>
                <a class="btn btn-light mb-3 p-3" href="#salesreport">Sales Report</a>
            </div>
            <div class="flex-grow-1 p-3">

                <div id="profiledetails">
                    <form action="profileurl">
                        <% ResultSet rs=st.executeQuery("select * from profile_details where userid='"+userid+"' ;" ); %>
                        <% while(rs.next()){ %>
                        <h2>Profile Details</h2>
                        <label class="form-label">User ID:</label>
                        <input type="text" class="form-control mb-2" value="<%= rs.getString(1)%>" readonly>
                        <label class="form-label">Name:</label>
                        <input type="text" class="form-control mb-2" name="name" value="<%= rs.getString(2)%>">
                        <label class="form-label">Location:</label>
                        <input type="text" class="form-control mb-2" name="location" value="<%= rs.getString(3)%>">
                        <label class="form-label">Mobile No:</label>
                        <input type="text" class="form-control mb-2" name="mobileno" value="<%= rs.getString(4)%>">
                        <label class="form-label">Email ID:</label>
                        <input type="email" class="form-control mb-2" name="emailid" value="<%= rs.getString(5)%>">
                        <label class="form-label">Password:</label>
                        <input type="text" class="form-control mb-2" name="password" value="<%= rs.getString(6)%>">
                        <input type="submit" value="save" class="btn btn-primary w-100">
                        <% } %>
                    </form>
                </div>
                <div id="stocklist" class="table-responsive show_hide">
                    <table  class="table table-hover caption-top table-bordered">
                        <caption> <h2>Stock Details : </h2></caption>
                        <thead class="table-info text-center fw-bolder">
                            <tr><td>Product id</td><td>Product Name</td><td>Price</td><td>Quantity</td><td>Total Value</td></tr>
                        </thead>
                        <tbody >
                            <%   
                            ResultSet Updateprice=st.executeQuery("select * from "+userid+"_stock_list ;");
                            Statement stt=con.createStatement();
                            Statement sttt=con.createStatement();
                            while(Updateprice.next()){
                                ResultSet getprice=stt.executeQuery("select price from admin_stock_list where product_id='"+Updateprice.getString(1)+"' ;");
                                if(getprice.next()){
                                sttt.executeUpdate("update "+userid+"_stock_list set price="+getprice.getInt(1)+" where product_id='"+Updateprice.getString(1)+"' ;");
                                }
                                }
                            %>
                            <%
                                int q=0;
                                int t=0;
                                ResultSet list=st.executeQuery("select * from "+userid+"_stock_list ;");
                                while(list.next())
                                {
                                out.println("<tr><td>"+list.getString(1)+"</td><td>"+list.getString(2)+"</td><td>"+list.getInt(4)+"</td><td>"+list.getInt(3)+"</td><td>"+list.getInt(5)+"</td></tr>");
                                q+=list.getInt(4);
                                t+=list.getInt(5);
                            }
                            out.println("<tr class=\"table-info text-center fw-bolder\"><td colspan=\"3\"> Total </td><td>"+q+"</td><td>"+t+"</td></tr>");
                            %>
                        </tbody>
                    </table>
                </div>
                <div id="orderstock" class="show_hide">
                <form method="post">
                    <h3 class="fw-bold mb-4"> Order stock  : </h3>
                    <label for="products"> <h5> Choose the Product Id : </h5> </label>
                    <select id="products" name="product_details" class="btn btn-primary pe-5 ms-4">
                    <% 
                      ResultSet product=st.executeQuery("select product_id from admin_stock_list ;");
                      
                      while(product.next())
                      {
                        out.println("<option  value="+product.getString(1)+">"+product.getString(1)+"</option>");
                      }     
                      String sell=request.getParameter("product_details");
                            if(sell!=null){
                            out.println("<option  value="+sell+"  style=\"display: none;\" selected>"+sell+"</option>");
                            }
                    %>
                    </select>
                    <input type="submit" class=" btn btn-info ms-4" value="Get Details" />
                    </form> 
                    <div>
                        <form action="userservletpackurl">
                        <input type="hidden" value="order" name="action" />
                        <script>
                           function totalvalue(qty){
                               let q=parseInt(qty);
                               let pri=document.getElementsByName("pr_pri")[0].value;
                               let price=parseInt(pri);
                               let totalprice=price * q;
                               document.getElementsByName("cost")[0].value=totalprice;
                            } 
                            
                        </script>
                        <% 
                            String pr_id=request.getParameter("product_details");
                            product=st.executeQuery("select * from admin_stock_list where product_id = '"+pr_id+"' ;");
                            while(product.next()){
                        %>
                        <table width="100%">
                        <tr height="80px" > 
                            <td class="fw-bold mx-3"> Product Id :</td><td class="mx-3"> <input type="text"  name="pr_id" class="form-control w-auto" value="<%= product.getString(1) %>" readonly/>
                            <td class="fw-bold mx-3"> Product Name :</td><td class="mx-3"> <input type="text" name="pr_name" class="form-control w-auto"  value="<%= product.getString(2) %>" readonly/>
                            <td class="fw-bold mx-3"> Price :</td><td class="mx-3"> <input type="text" name="pr_pri" class="form-control w-auto"  value="<%= product.getInt(4) %>" readonly/></tr>
                        <tr height="80px"> 
                            <td class="fw-bold mb-3"> Quantity :</td><td> <input type="text" class="form-control w-auto" name="alt_qty" placeholder="Quantity needed" oninput="totalvalue(this.value)"/> </td>
                            <td class="fw-bold mb-3"> Total Cost :</td><td> <input type="text" class="form-control w-auto" name="cost" placeholder="Total Cost" readonly/> </td>
                            <td class="fw-bold mb-3"><button type="submit" class="btn btn-success fw-bold w-100" >Order</button></td> </tr>  
                        </table>
                        <% } %>
                        </form>
                    </div>
                </div>         
                <div id="stockintransit" class="table-responsive show_hide">
                    <table  class="table table-hover caption-top table-bordered">
                        <caption> <h2>Orders In-Transit </h2></caption>
                        <thead class="table-info text-center fw-bolder">
                            <tr><td>Order Date</td><td>user Id</td><td>Product id</td><td>Product Name</td><td>Price</td><td>Quantity</td><td>Total Value</td><td>Received</td></tr>
                        </thead>
                        <tbody >
                        <%
                                int no_orders_transit=0;
                                ResultSet orderlist=st.executeQuery("select * from orders where in_transit=1 and received=0 and userid='"+userid+"' ;");
                                while(orderlist.next())
                                {
                                out.println("<form action=\"userservletpackurl\" method=\"get\" >");
                                out.println("<input type=\"hidden\" value=\"orderreceivedupdate\" name=\"action\" >");
                                out.println("<input type=\"hidden\" value=\""+orderlist.getLong(1)+"\" name=\"orderid\" >");
                                out.println("<input type=\"hidden\" value=\""+orderlist.getString(4)+"\" name=\"pro_id\" >");
                                out.println("<input type=\"hidden\" value=\""+orderlist.getInt(7)+"\" name=\"or_qty\" >");
                                out.println("<input type=\"hidden\" value=\""+orderlist.getInt(6)+"\" name=\"price\" >");
                                out.println("<tr><td>"+orderlist.getDate(2)+"</td><td>"+orderlist.getString(3)+"</td><td>"+orderlist.getString(4)+"</td><td>"+orderlist.getString(5)+"</td><td>"+orderlist.getInt(6)+"</td><td>"+orderlist.getInt(7)+"</td><td>"+orderlist.getInt(8)+"</td>");
                                out.println("<td><input type=\"submit\" value=\"Received\" ></td></tr>");
                                out.println("</form>");
                                no_orders_transit++;
                                }
                                
                            %>    
                        <caption><h5> <h5> Total No of stock In-transit : <%= no_orders_transit %>  </h5></caption>
                        </tbody>
                    </table>
                </div>            
                <div id="billing" class="billContainer">
                <div class="bill_box card p-4 shadow-lg">
                    <h4> Billing : </h4>
                    <script>
                           function billtotalvalue(qty){
                               let q=parseInt(qty);
                               let pri=document.getElementsByName("Pro_value")[0].value;
                               let price=parseInt(pri);
                               let totalprice=price * q;
                               document.getElementsByName("b_t_value")[0].value=totalprice;
                            } 
                            
                        </script>
                    <form>
    
                        <table>
                            <%
                                int Bill_no=1001;
                                String cname="";
                              ResultSet billno=st.executeQuery("select bill_no from "+userid+"_sales where sales=1;");
                              
                              if(billno.last()){
                                       Bill_no=billno.getInt(1)+1;
                                }
                               ResultSet name=st.executeQuery("select customer_name from "+userid+"_sales where sales=0;");
                                if(name.next()){
                                    cname=name.getString(1);
                                }
                                
                            %>
                            <tr class="mb-3 " style="height: 90px;"><td><span class="form-label "> Bill No :</span> <input class="form-control fw-semibold" type="text" id="b1" name="bill_no" placeholder="Bill No" value="<%= Bill_no %>" readonly></td>
                            <td ><span class="form-label ">Customer Name : </span><input class="form-control fw-semibold" type="text" id="c1" name="customer_name" placeholder="Customer Name" value="<%= request.getParameter("customer_name") != null ? request.getParameter("customer_name") : cname  %>" required></td></tr>
                            <tr class=" row mb-3 " style="height: 60px;"><td><span class="form-label "> <label for="products"> Choose the Product Id : </label></span>
                            <select id="products" class="form-select fw-semibold" name="productt_details" onchange="this.form.submit()">
                            <% 
                            product=st.executeQuery("select product_id from "+userid+"_stock_list ;");
                             out.println("<option> Select </option>");
                            while(product.next())
                            {
                            out.println("<option  value="+product.getString(1)+">"+product.getString(1)+"</option>");
                            }
                            String sel=request.getParameter("productt_details");
                            if(sel!=null){
                            out.println("<option  value="+sel+"  style=\"display: none;\" selected>"+sel+"</option>");
                            }
                            %>
                            </select></td></tr>
                            <%      
                            String pro_id=request.getParameter("productt_details");
                            String pro_name="";
                            int pro_value=0;
                            ResultSet productdetails=st.executeQuery("select * from admin_stock_list where product_id='"+pro_id+"' ;");
                            if(productdetails.next()){
                                pro_name=productdetails.getString(2);
                                pro_value=productdetails.getInt(4);                            
                                }
                            %>
                        </table>
                        </form>
                        <form action="userservletpackurl">
                            <script >
                                function assign(){
                                document.getElementById("bill").value=document.getElementById("b1").value;
                                document.getElementById("cname").value=document.getElementById("c1").value;
                                document.getElementsByName("pro_details")[0].value="<%=  pro_id  %>";
                            }
                            </script>
                            <input type="hidden" name="action" value="bill_add_product">
                            <input type="hidden" name="bill_no" id="bill">
                            <input type="hidden" name="customer_name" id="cname">
                            <input type="hidden" name="pro_details" id="bpid">
                    <table >
                        <tr class="mb-3 " style="height: 90px;"><td><span class="form-label ">Product Name : </span><input type="text" class="form-control fw-semibold" name="Pro_name" value="<%= pro_name !="" ? pro_name :""   %>" placeholder="Product Name" required></td>
                            <td><span class="form-label ">Product price : </span><input type="text" class="form-control fw-semibold" name="Pro_value" value="<%= pro_value !=0 ? pro_value :""  %>" placeholder="Product Price" required></td></tr>
                            <tr class="mb-3 " style="height: 80px;"><td><span class="form-label ">Quantity : </span><input type="text" class="form-control fw-semibold" name="qty" placeholder="Quantity" oninput="billtotalvalue(this.value)" required></td>
                            <td><span class="form-label ">Total value : </span><input type="text" class="form-control fw-semibold" name="b_t_value" placeholder="Total value"></td></tr>                            
                            <tr lass="d-flex justify-content-between" style="height: 30px;"><td><input type="submit" name="bill_add_product" value="Add" class="btn btn-primary fw-bold" onclick="assign();" required></td>
                            </tr>                           
                        </table>
                    </form>
                    <form action="userservletpackurl" class="mt-3">
                        <input type="hidden" name="action" value="bill_reset">
                        <input type="submit"  class="btn btn-secondary fw-bold " value="Reset">
                    </form>
                    <form action="userservletpackurl" class="mt-3">
                        <input type="hidden" name="action" value="bill_complete">
                        <input type="submit" name="Complete" class="btn btn-success w-100 fw-bold" value="complete">
                    </form>




                </div>
                <div class="bill_box  table-responsive">
                    <table  class="table table-hover caption-top table-bordered">
                        
                        <thead class="table-info text-center fw-bolder">
                            <tr><td>Sl.no</td><td>Product id</td><td>Product Name</td><td>Price</td><td>Quantity</td><td>Total Value</td></tr>
                        </thead>
                        <tbody >
                            <%
                                int qq=0;
                                int tt=0;
                                int s=0;
                                list=st.executeQuery("select * from "+userid+"_sales where sales=0 ;");
                                while(list.next())
                                {
                                s++;
                                out.println("<tr><td>"+s+"</td><td>"+list.getString(4)+"</td><td>"+list.getString(5)+"</td><td>"+list.getInt(7)+"</td><td>"+list.getInt(6)+"</td><td>"+list.getInt(8)+"</td></tr>");
                                qq+=list.getInt(6);
                                tt+=list.getInt(8);
                            }
                            out.println("<tr class=\"table-info text-center fw-bolder\"><td colspan=\"4\"> Total </td><td>"+qq+"</td><td>"+tt+"</td></tr>");
                            %>
                        </tbody>
                    </table>
                </div>
                </div>  
                <div id="salesreport" class="table-responsive show_hide">
                    <table  class="table table-hover caption-top table-bordered">
                        <caption> <h2>Sales Report : </h2></caption>
                        <thead class="table-info text-center fw-bolder">
                            <tr><td>Sl.no</td><td>Bill No</td><td>Sale Date</td><td>Customer Name</td><td>Total Quantity</td><td>Total Value</td></tr>
                        </thead>
                        <tbody >
                            <%
                                int ss=0;
                                
                                 list=st.executeQuery("select bill_no,sale_date,customer_name,SUM(qty),sum(total_value) from "+userid+"_sales GROUP by bill_no order by bill_no;");
                                while(list.next())
                                {
                                ss++;
                                out.println("<tr><td>"+ss+"</td><td>"+list.getInt(1)+"</td><td>"+list.getString(2)+"</td><td>"+list.getString(3)+"</td><td>"+list.getInt(4)+"</td><td>"+list.getInt(5)+"</td></tr>");
                                
                            }
                            
                            %>
                        </tbody>
                    </table>
                </div>
                            
                            
                            
                </div>
                       
            </div>
        </div>

    </body>
</html>