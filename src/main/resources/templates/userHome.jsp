<input type="hidden" <%@ page contentType="text/html;charset=UTF-8" language="java" %>
<input type="hidden" <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>UsersTable</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
</head>
<body id="headBody">

<div style="height: 100%;">

    <nav class="navbar navbar-dark bg-dark">
        <div>
            <span id="headNavbar" class="navbar-brand h1 px-md-3">Navbar</span>
            <span class="navbar-text">with roles: </span>
            <span id="roleNavbar" class="navbar-text">Navbar</span>
        </div>
        <a class="navbar-text px-md-3" href="/logout">Logout</a>
    </nav>

    <div class="row no-gutters" style="height: 100%;">
        <div class="col-2 h-100">
            <br>
            <ul id="navPanel" class="nav flex-column nav-pills" aria-orientation="vertical">
                <div id="AdminNav"></div>
                <div id="UserNav"></div>
            </ul>
        </div>
        <div class="col-10 bg-light px-md-5 h-100 d-inline-block">
            <br>
            <h1>User information-page</h1>
            <br>
            <div class="card">
                <div class="card-header">
                    <h4>About user</h4>
                </div>
                <div class="card-body">
                    <table class="table table-striped">
                        <thead>
                        <tr>
                            <th scope="col">ID</th>
                            <th scope="col">FirstName</th>
                            <th scope="col">LastName</th>
                            <th scope="col">Age</th>
                            <th scope="col">Email</th>
                            <th scope="col">Role</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr id="userInfo">

                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    fetch("/api/user").then(response => response.json()
    ).then(thisUser => {
        let htmlRoles = "";
        let htmlRoleNavbar = "";
        let roleThisUser = thisUser.roles;
        for (let i = 0; i < roleThisUser.length; i++) {
            if (roleThisUser[i].name == "ROLE_ADMIN") {
                document.querySelector("#AdminNav").innerHTML = `
                    <li class="nav-item">
                        <a class="nav-link" href="/admin">Admin</a>
                    </li>`;
            }

            if (roleThisUser[i].name == "ROLE_USER") {
                document.querySelector("#UserNav").innerHTML = `
                    <li class="nav-item">
                        <a class="nav-link active" href="/user">User</a>
                    </li>`;
            }
            htmlRoles = htmlRoles + "<div>" + roleThisUser[i].name.slice(5) + "</div>";
            htmlRoleNavbar += `${roleThisUser[i].name.slice(5)} `;
        }
        document.querySelector("#headNavbar").innerHTML = `${thisUser.email}`;
        document.querySelector("#roleNavbar").innerHTML = `${htmlRoleNavbar}`;

        document.querySelector(`#userInfo`).innerHTML = `
                    <td>${thisUser.id}</td>
                    <td>${thisUser.firstName}</td>
                    <td>${thisUser.lastName}</td>
                    <td>${thisUser.age}</td>
                    <td>${thisUser.email}</td>
                    <td>${htmlRoles}</td>`
    });
</script>


<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.1/jquery.min.js"></script>
<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js" integrity="sha384-oBqDVmMz9ATKxIep9tiCxS/Z9fNfEXiDAYTujMAeBAsjFuCZSmKbSSUnQlmh/jp3" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
</body>
</html>