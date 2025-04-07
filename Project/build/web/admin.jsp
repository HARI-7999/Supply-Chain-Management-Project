<%-- 
    Document   : admin
    Created on : 18-Mar-2025, 5:09:33 pm
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
                        <span class="fw-bold">Admin</span>
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
                <a class="btn btn-light mb-2 p-2" href="#dashboard">Dashboard</a>
                <a class="btn btn-light mb-2 p-2" href="#ordersview">Orders</a>
                

                <div class="mt-3">
                    <h5 class="text-white">Distributors</h5>
                    <a class="btn btn-light w-100 mb-1 p-2" href="#userlist">View Details</a>
                    <a class="btn btn-light w-100 mb-1 p-2" href="#useradd">Add</a>
                    <a class="btn btn-light w-100 mb-1 p-2" href="#removedistributors">Remove</a>
                </div>

                <div class="mt-3">
                    <h5 class="text-white">Products</h5>
                    <a class="btn btn-light w-100 mb-1 p-2" href="#addproduct">Add</a>
                    <a class="btn btn-light w-100 mb-1 p-2" href="#alterproduct">Alter Price/Quantity</a>
                    <a class="btn btn-light w-100 p-2" href="#removeproduct">Remove</a>
                </div>
            </div>
            <div class="flex-grow-1 p-3">

                <div id="profiledetails">
                    <% 
                        String id=(String) session.getAttribute("id");
                        String userid="",name="",location="";
                        String mobileno="";
                        String emailid="",password="";
                       ResultSet profile=st.executeQuery("select * from profile_details where userid = '"+id+"' ;");
                        while (profile.next())
                                {
                                    userid=profile.getString(1);
                                    name=profile.getString(2);
                                    location=profile.getString(3);
                                    mobileno=profile.getString(4);
                                    emailid=profile.getString(5);
                                    password=profile.getString(6);
                                }
                
                    %>
                    <form action="profileurl">
                        <h2>Profile Details</h2>
                        <label class="form-label">User ID:</label>
                        <input type="text" class="form-control mb-2" name="userid" value=<%= userid %> readonly>
                        <label class="form-label">Name:</label>
                        <input type="text" class="form-control mb-2" name="name" value=<%= name %>>
                        <label class="form-label">Location:</label>
                        <input type="text" class="form-control mb-2" name="location" value=<%= location %>>
                        <label class="form-label">Mobile No:</label>
                        <input type="text" class="form-control mb-2" name="mobileno" value=<%= mobileno %>>
                        <label class="form-label">Email ID:</label>
                        <input type="email" class="form-control mb-2" name="emailid" value=<%= emailid %>>
                        <label class="form-label">Password:</label>
                        <input type="type" class="form-control mb-2" name="password" value=<%= password %>>
                        <input type="submit" value="save" class="btn btn-primary w-100">
                    </form>
                </div>
                <div id="dashboard" class="table-responsive">
                    <table  class="table table-hover caption-top table-bordered">
                        <caption> <h2>Stock Details : </h2></caption>
                        <thead class="table-info text-center fw-bolder">
                            <tr><td>Product id</td><td>Product Name</td><td>Price</td><td>Quantity</td><td>Total Value</td></tr>
                        </thead>
                        <tbody >
                            <%
                                int q=0;
                                int t=0;
                                ResultSet list=st.executeQuery("select * from admin_stock_list ;");
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
                <div id="addproduct" class="container-fluid">
                    <h3 class="fw-bold mb-4"> Add New Product : </h3>
                    <h5 class="mb-4"> Enter the product details : </h5>
                    <form action="addproducturl">
                        <table>
                            <tr height="80px" > <td class="fw-bold mb-3" width="140px"> Product Id :</td><td> <input type="text" class="form-control"name="productid" /></tr>
                            <tr height="80px"> <td class="fw-bold mb-3"> Product Name :</td><td> <input type="text" class="form-control" name="productname" /></tr>
                            <tr height="80px"> <td class="fw-bold mb-3"> Price :</td><td> <input type="text" class="form-control" name="price" /></tr>
                            <tr height="80px"> <td class="fw-bold mb-3"> Quantity :</td><td> <input type="text" class="form-control" name="qty" /></tr>
                            <tr height="80px"> <td class="fw-bold mb-3"> <input class="btn btn-outline-warning" type="reset" Value="Clear"/></td><td><input class="btn btn-outline-success" type="submit" value="Add"/></tr>
                        </table>
                    </form>
                </div>
                <div id="removeproduct">
                    <form method="post">
                        <h3 class="fw-bold mb-4"> Remove the Product from the stock list : </h3>
                        <label for="pdts"> <h5> Choose the product Id  : </h5> </label>
                        <select id="pdts" name="remove" class="btn btn-primary pe-5 ms-4">
                            <% 
                                list=st.executeQuery("select * from admin_stock_list ;");
                                while(list.next())
                                {
                                    out.println("<option  value="+list.getString(1)+">"+list.getString(1)+"</option>");
                            }
                            String rr=request.getParameter("remove");
                            if(rr!=null){
                            out.println("<option  value="+rr+"  style=\"display: none;\" selected>"+rr+"</option>");
                            }                            
                            
                            %>
                        </select>
                        <input type="submit" class=" btn btn-info ms-4" value="Get Details" />
                    </form>
                    <div id="removeproduct_details" >
                        <% 
                       String remove=request.getParameter("remove");
                       if(remove!="")
                       {
                       list=st.executeQuery("select * from admin_stock_list where product_id='"+remove+"' ;");
                       while(list.next())
                       {
                        %>
                        <form action="servletpackurl">
                            <input type="hidden" name="action" value="productremove" >
                            <input type="hidden" name="id" value="<%=list.getString(1) %>" >
                            <table>
                                <tr height="60px" class="fw-bold mb-1"> <td  width="140px"> Product Id :</td> <td> <%=list.getString(1) %></td></tr>
                                <tr height="60px" class="fw-bold mb-1"> <td > Product Name :</td><td> <%=list.getString(2) %> </td>  </tr>
                                <tr height="60px" class="fw-bold mb-1"> <td > Price :</td><td> <%=list.getString(3) %></td></tr>
                                <tr height="60px" class="fw-bold mb-1"> <td > Quantity :</td><td><%=list.getString(4) %></td></tr>
                                <tr height="60px" class="fw-bold mb-1" > <td > Total Value :</td><td> <%=list.getString(5) %></td></tr>
                                <tr height="60px" class="fw-bold mb-1"> <td></td><td><input class="btn btn-outline-success" type="submit" value="Remove" /></td></tr>
                            </table>
                        </form>
                        <%
                        }
                        }   
                                                          
                        %>
                    </div>

                </div>
                    <div id="alterproduct">
                    <form action="" method="post">
                        <h3 class="fw-bold mb-4"> Alter the Price/Quantity of the Product : </h3>
                        <label for="pdts"> <h5> Choose the product Id  : </h5> </label>
                        <select id="pdts" name="remoove" class="btn btn-primary pe-5 ms-4">
                            <% 
                                list=st.executeQuery("select * from admin_stock_list ;");
                                while(list.next())
                                {
                                    out.println("<option  value="+list.getString(1)+">"+list.getString(1)+"</option>");
                            }
                            String se=request.getParameter("remoove");
                            if(se!=null){
                            out.println("<option  value="+se+"  style=\"display: none;\" selected>"+se+"</option>");
                            }                            
                            
                            %>
                        </select>
                        <input type="submit" class=" btn btn-info ms-4" value="Get Details" />
                    </form>
                    <div id="alterproduct_details" >
                        <% 
                       String remmove=request.getParameter("remoove");
                       if(remmove!="")
                       {
                       list=st.executeQuery("select * from admin_stock_list where product_id='"+remmove+"' ;");
                       while(list.next())
                       {
                        %>
                        <form action="servletpackurl">
                            <input type="hidden" name="action" value="productalter" >
                            <input type="hidden" name="id" value="<%=list.getString(1) %>" >
                            <table>
                                <table>
                            <tr height="80px" > <td class="fw-bold mb-3" width="140px"> Product Id :</td><td> <input type="text" class="form-control" value="<%= list.getString(1) %>" readonly/></tr>
                            <tr height="80px"> <td class="fw-bold mb-3"> Product Name :</td><td> <input type="text" class="form-control"  value="<%= list.getString(2) %>" readonly/></tr>
                            <tr height="80px"> <td class="fw-bold mb-3"> Price :</td><td> <input type="text" class="form-control" name="alt_price" value="<%= list.getInt(4) %>"/></tr>
                            <tr height="80px"> <td class="fw-bold mb-3"> Quantity :</td><td> <input type="text" class="form-control" name="alt_qty" value="<%= list.getInt(3) %>" readonly/>
                                <td class="fw-bold mb-3"> Add\Less Quantity :</td><td> <input type="text" class="form-control" name="alt_qty_add" placeholder="Add Quantity" />
                            </tr>
                            <tr height="80px"> <td></td><td><input class="btn btn-outline-success" type="submit" value="Alter" /></td></tr>
                            </table>
                        </form>
                        <%
                        }
                        }                                  
                        %>
                    </div>
                </div>
                    <div id="userlist" class="table-responsive">
                    <table  class="table table-hover caption-top table-bordered">
                        <caption> <h2>Distributors Details : </h2></caption>
                        <thead class="table-info text-center fw-bolder">
                            <tr><td>User id</td><td>Name</td><td>Location</td><td>Contact No</td><td>Email Id</td></tr>
                        </thead>
                        <tbody >
                            <%
                                ResultSet userlist=st.executeQuery("select * from profile_details where Approval=1;");
                                userlist.next();
                                while(userlist.next())
                                {
                                
                                out.println("<tr><td>"+userlist.getString(1)+"</td><td>"+userlist.getString(2)+"</td><td>"+userlist.getString(3)+"</td><td>"+userlist.getString(4)+"</td><td>"+userlist.getString(5)+"</td></tr>");
                                
                            }
                            %>
                        </tbody>
                    </table>
                </div>
                <div id="useradd" class="container-fluid">
                    <table  class="table table-hover caption-top table-bordered">
                        <caption> <h2>Add New Distributors  : </h2></caption>
                        <thead class="table-info text-center fw-bolder">
                            <tr><td>User id</td><td>Name</td><td>Location</td><td>Contact No</td><td>Email Id</td><td> ADD </td></tr>
                        </thead>
                        <tbody >
                            <%
                                ResultSet newuserlist=st.executeQuery("select * from profile_details where Approval=0;");
                                
                                while(newuserlist.next())
                                {
                                
                                out.println("<form action=\"servletpackurl\" method=\"get\" ><input type=\"hidden\" value=\""+newuserlist.getString(1)+"\" name=\"addid\" >"
                                + "<input type=\"hidden\" value=\"useradd\" name=\"action\"> <tr><td>"+newuserlist.getString(1)+"</td><td>"+newuserlist.getString(2)+"</td><td>"+newuserlist.getString(3)+"</td><td>"+newuserlist.getString(4)+"</td><td>"+newuserlist.getString(5)+"</td>"
                                + "<td> <input type=\"submit\" Value=\"Add\"></td></tr>"
                                + "</form>");
                     
                            }
                            %>
                        </tbody>
                    </table>
                </div>
                <div id="removedistributors">
                    <form method="post">
                    <h3 class="fw-bold mb-4"> Remove the Distributor  : </h3>
                    <label for="dealers"> <h5> Choose the Distributors user Id  : </h5> </label>
                    <select id="dealers" name="removedealers" class="btn btn-primary pe-5 ms-4">
                    <% 
                      userlist=st.executeQuery("select * from profile_details;");
                      userlist.next();
                      while(userlist.next())
                      {
                        out.println("<option  value="+userlist.getString(1)+">"+userlist.getString(1)+"</option>");
                      }
                      String sell=request.getParameter("removedealers");
                            if(sell!=null){
                            out.println("<option  value="+sell+"  style=\"display: none;\" selected>"+sell+"</option>");
                            }
                    %>
                    </select>
                    <input type="submit" class=" btn btn-info ms-4" value="Get Details" />
                    </form>
                    <div id="removeproduct_details" >
                    <% 
                     String dealerremove=request.getParameter("removedealers");
                     if(remove!="")
                     {
                     userlist=st.executeQuery("select * from profile_details where userid='"+dealerremove+"' ;");
                     while(userlist.next())
                     {
                     %>
                    <form action="servletpackurl">
                    <input type="hidden" name="action" value="dealerremove" >
                    <input type="hidden" name="id" value="<%=userlist.getString(1) %>" >
                    <table>
                    <tr height="60px" class="fw-bold mb-1"> <td  width="140px"> User_id :</td> <td> <%=userlist.getString(1) %></td></tr>
                    <tr height="60px" class="fw-bold mb-1"> <td > Name :</td><td> <%=userlist.getString(2) %> </td>  </tr>
                    <tr height="60px" class="fw-bold mb-1"> <td > Location :</td><td> <%=userlist.getString(3) %></td></tr>
                    <tr height="60px" class="fw-bold mb-1"> <td > Mobile no :</td><td><%=userlist.getString(4) %></td></tr>
                    <tr height="60px" class="fw-bold mb-1" > <td > Email id :</td><td> <%=userlist.getString(5) %></td></tr>
                    <tr height="60px" class="fw-bold mb-1"> <td></td><td><input class="btn btn-outline-success" type="submit" value="Remove" /></td></tr>
                    </table>
                    </form>
                    <%
                    }
                    }   
                    %>
                    </div>
                </div>
                    <div id="ordersview" class="show_hide">
                    <table  class="table table-hover caption-top table-bordered">
                        <caption> <h2>Order received : </h2></caption>
                        <thead class="table-info text-center fw-bolder">
                            <tr><td>Order Date</td><td>user Id</td><td>Product id</td><td>Product Name</td><td>Price</td><td>Quantity</td><td>Total Value</td><td>Transfer</td></tr>
                        </thead>
                        <tbody >
                            <%
                                int no_orders=0;
                                ResultSet orderlist=st.executeQuery("select * from orders where in_transit=0 and received=0;");
                                while(orderlist.next())
                                {
                                out.println("<form action=\"servletpackurl\" >");
                                out.println("<input type=\"hidden\" value=\"ordertransfer\" name=\"action\" >");
                                out.println("<input type=\"hidden\" value=\""+orderlist.getLong(1)+"\" name=\"orderid\" >");
                                out.println("<input type=\"hidden\" value=\""+orderlist.getString(4)+"\" name=\"pro_id\" >");
                                out.println("<input type=\"hidden\" value=\""+orderlist.getInt(7)+"\" name=\"or_qty\" >");
                                out.println("<tr><td>"+orderlist.getDate(2)+"</td><td>"+orderlist.getString(3)+"</td><td>"+orderlist.getString(4)+"</td><td>"+orderlist.getString(5)+"</td><td>"+orderlist.getInt(6)+"</td><td>"+orderlist.getInt(7)+"</td><td>"+orderlist.getInt(8)+"</td>");
                                out.println("<td><input type=\"submit\" value=\"Transfer\" ></td></tr>");
                                out.println("</form>");
                                no_orders++;
                                }
                                
                            %>
                        <caption> <h5> Pending Orders : <%= no_orders %> </h5></caption>
                        </tbody>
                    </table><br>
                    <table  class="table table-hover caption-top table-bordered">
                        <caption> <h2>Orders In-Transit </h2></caption>
                        <thead class="table-info text-center fw-bolder">
                            <tr><td>Order Date</td><td>user Id</td><td>Product id</td><td>Product Name</td><td>Price</td><td>Quantity</td><td>Total Value</td></tr>
                        </thead>
                        <tbody >
                            <%
                                int no_orders_transit=0;
                                orderlist=st.executeQuery("select * from orders where in_transit=1 and received=0;");
                                while(orderlist.next())
                                {
                                out.println("<tr><td>"+orderlist.getDate(2)+"</td><td>"+orderlist.getString(3)+"</td><td>"+orderlist.getString(4)+"</td><td>"+orderlist.getString(5)+"</td><td>"+orderlist.getInt(6)+"</td><td>"+orderlist.getInt(7)+"</td><td>"+orderlist.getInt(8)+"</td></tr>");
                                no_orders_transit++;
                                }
                                
                            %>
                        <caption> <h5> Orders in transit : <%= no_orders_transit %> </h5></caption>
                        </tbody>
                    </table>
                </div>   
            </div>
        </div>

    </body>
</html>
