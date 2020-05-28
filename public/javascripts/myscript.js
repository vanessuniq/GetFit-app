function myGreeting() {
    var greeting;
    var d = new Date();
    var t = d.getHours();
    if (t > 18) {
        greeting = "Good evening"
    } else if (t > 10) {
        greeting = "Good day"
    } else {
        greeting = "Good morning"
    }
    document.getElementById("greet").innerHTML = greeting;
}