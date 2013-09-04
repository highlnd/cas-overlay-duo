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

            <c:if test="${not pageContext.request.secure}">
                <div id="msg" class="errors">
                    <h2>Non-secure Connection</h2>
                    <p>You are currently accessing CAS over a non-secure connection.  Single Sign On WILL NOT WORK.  In order to have single sign on work, you MUST log in over HTTPS.</p>
                </div>
            </c:if>

            <iframe id="duo_iframe" width="100%" height="310" frameborder="0" class="fm-v clearfix"></iframe>

            <form:form method="post" id="duo_form" commandName="${commandName}" htmlEscape="true">
                <input type="hidden" name="lt" value="${loginTicket}" />
                <input type="hidden" name="execution" value="${flowExecutionKey}" />
                <input type="hidden" name="_eventId" value="submit" />
            </form:form>

            <div id="footer" class="footer_area">
                <div>

                    <p>&copy; 2013 Regents of the University of California<br /> <a target="_blank" href="http://cnc.ucr.edu">Computing &amp; Communications</a></p>

                </div>

            </div>

        </div>

    </c:when>
    <c:otherwise>
        <div id="header-image">
            <img src="images/cas_header.png" alt="CAS">
        </div>

        <form:form method="post" id="duo_form" cssClass="fm-v clearfix" commandName="${commandName}" htmlEscape="true">

            <p>Since this is the first time that you are signing into this service you will need to scan the barcode below to generate a secret to continue.</p>
            <center>
            <div class="box fl-panel" id="login">

            <img src="<c:url value='/totpcode?username=${username}@ucr.edu&secret=${totpSecret}' />"/>

            <input type="hidden" name="execution" value="${flowExecutionKey}" />
            <input type="hidden" name="_eventId" value="submit" />


                <input type="submit" class="btn-submit" name="submit" accesskey="l" value="Continue" alt="Continue">
            </div>

            </center>
        </form:form>


        <div id="footer-section">
            <p>
                &copy; 2011 Regents of the University of California - <a href="http://cnc.ucr.edu" target="_blank">Computing &amp; Communications
            </p>
        </div>

    </c:otherwise>
</c:choose>
<jsp:directive.include file="includes/bottom.jsp" />
