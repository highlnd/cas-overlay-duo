<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%--

Licensed to Jasig under one or more contributor license
agreements. See the NOTICE file distributed with this work
for additional information regarding copyright ownership.
Jasig licenses this file to you under the Apache License,
Version 2.0 (the "License"); you may not use this file
except in compliance with the License. You may obtain a
copy of the License at:

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on
an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied. See the License for the
specific language governing permissions and limitations
under the License.

--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<jsp:directive.include file="includes/top.jsp" />
<c:choose>
<c:when test="${not empty requestScope['isMobile']}">
<div id="header" class="fl-navbar">
    <h3 id="app-name" class="fl-table-cell accessible">Central Authentication Service (CAS)</h3>
</div>		
<div id="content" class="fl-screenNavigator-scroll-container">

<form:form method="post" id="fm1" cssClass="fm-v clearfix" commandName="${commandName}" htmlEscape="true">

        <div class="box fl-panel" id="login">
            <!-- Congratulations on bringing CAS online!  The default authentication handler authenticates where usernames equal passwords: go ahead, try it out.  -->

            <div class="row fl-controls-left">
                <label for="username" class="fl-label">NetID:</label>

                <form:input cssClass="required" cssErrorClass="error" id="username" size="25" tabindex="1" path="username" autocomplete="false" htmlEscape="true" />

            </div>
            <div class="row fl-controls-left">
                <label for="password" class="fl-label">Password:</label>
                <form:password cssClass="required" cssErrorClass="error" id="password" size="25" tabindex="2" path="password"  accesskey="${passwordAccessKey}" htmlEscape="true" autocomplete="off" />
            </div>
            <div class="row check">
                <input id="warn" name="warn" value="true" tabindex="3" accesskey="w" type="checkbox">
                <label for="warn">Warn me before logging me into other sites.</label>
            </div>
            <div class="row btn-row">
                <input type="hidden" name="lt" value="${loginTicket}" />
                <input type="hidden" name="execution" value="${flowExecutionKey}" />
                <input type="hidden" name="_eventId" value="submit" />

                <input type="image" alt="Login Now" tabindex="4" value="LOGIN" accesskey="l" name="submit" class="btn-submit" src="images/login_small.png">

                </div>
            </div>
            <form:errors path="*" cssClass="errors" id="status" element="div" />
            </form:form>
            <div id="footer" class="footer_area">
                <div>

                    <p>&copy; 2011 Regents of the University of California<br /> <a target="_blank" href="http://cnc.ucr.edu">Computing &amp; Communications</a></p>

                </div>

            </div>

        </div>

        </c:when>
        <c:otherwise>
        <div id="header-image">
            <img src="images/cas_header.png" alt="CAS">
        </div>
        <form:form method="post" id="fm1" cssClass="fm-v clearfix" commandName="${commandName}" htmlEscape="true">

            <p>You may authenticate now in order to access protected services later. For security reasons, quit your browser when you are done accessing services that require authentication.</p>
            <div class="box fl-panel" id="login">
                <!-- Congratulations on bringing CAS online!  The default authentication handler authenticates where usernames equal passwords: go ahead, try it out.  -->
                <table class="table_form">
                    <tbody>
                        <tr>
                            <td><label class="fl-label" for="username">UCR NetID: </label> </td> 
                            <td><form:input cssClass="required" cssErrorClass="error" id="username" size="25" tabindex="1" path="username" autocomplete="false" htmlEscape="true" /></td>
                            </tr>
                            <tr>
                                <td> <label for="password" class="fl-label">Password:</label> </td>
                                <td><form:password cssClass="required" cssErrorClass="error" id="password" size="25" tabindex="2" path="password"  accesskey="${passwordAccessKey}" htmlEscape="true" autocomplete="off" /></td>
                                </tr>

                                <tr>
                                    <td colspan="2"> 
                                        <input class="checkbox" id="warn" name="warn" value="true" tabindex="3" accesskey="w" type="checkbox">
                                        <span style="position:relative; top:-1px;">Warn me before logging me into other sites</span>
                                    </td>

                                    <tr>
                                        <td colspan="2">

                                            <input type="hidden" name="lt" value="${loginTicket}" />
                                            <input type="hidden" name="execution" value="${flowExecutionKey}" />
                                            <input type="hidden" name="_eventId" value="submit" />

                                            <input src="images/login.png" class="btn-submit" name="submit" accesskey="l" value="LOGIN" tabindex="4" type="image" alt="Login Now">
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <form:errors path="*" cssClass="errors" id="status" element="div" />
                            <div id="security-text">
                                <p>
                                Make sure you know and trust any webpage or program that asks for your UCR 
                                NetID & Password. For more information on Web security, trusted applications, 
                                and future plans please visit <a target="_blank" href="http://cnc.ucr.edu/websecurity/"> http://cnc.ucr.edu/websecurity. </a>
                                </p>
                            </div>

                            </form:form>

                            <div id="footer-section">
                                <p>
                                &copy; 2011 Regents of the University of California - <a href="http://cnc.ucr.edu" target="_blank">Computing &amp; Communications</p>
                                </div>

                            </div>


                        </div>
                    </div>
                </div>
                </c:otherwise>
                </c:choose>
                <jsp:directive.include file="includes/bottom.jsp" />
