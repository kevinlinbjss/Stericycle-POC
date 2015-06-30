
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Summary Status Report</title>
<!-- The config() function is the one which will contain all of the logic. It is executed when the "body" element is done loading, 
"<body onload="config()">", in this way we will have access to every element in the DOM. -->
<script type="text/javascript">
  function config() {
    
    var button = document.getElementById("btnRunReport");
    button.addEventListener("click", function(event) {
	    	event.preventDefault();  
	    	var eventId = document.getElementById("eventId").value;
		    window.location = "runReport?eventId=" + eventId;
	    }, true);
	}
</script>
<!-- Next on is the code referring to the style section. -->
<style type="text/css">
.common {
  border-radius: 3px;
  -moz-border-radius: 3px; /* Firefox */
  -webkit-border-radius: 3px; /* Safari y Chrome */
  border: 1px solid #333;
  width: 250px;
  padding: 10px;
  text-align: center;
}

.form {
  background: #eee;
  height: 160px;
}

.errorMsg {
  background: red;
  color: white;;
}

.hide {
  display: none;
}
</style>
</head>
<body onload="config()">
  <h2>Summary Status Report 2</h2>
  <h3>Run report using API</h3>
  <div class="common form">
    <b>Report Filter Parameter</b>
    <hr />
    <!-- The "id" of every Selector and that of the button, will be used to obtain the values of said elements as well as to assign event listeners using Javascript. -->
    <!-- eventId Selector -->
    <label for="eventId">EventId: </label> <input type="number" min="1000"
      max="9000" step="1" value="4440" autofocus placeholder="eventId"
      id="eventId" maxlength="4" size="6"> <br />
      <!-- report execution Button -->
    <button id="btnRunReport">Run Report</button>
  </div>
  <br />
 
</body>
</html>