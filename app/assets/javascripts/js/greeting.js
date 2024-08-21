function greetUser(element_id, user_name){
    var hour = new Date().getHours();
    var greeting = "";
    var imagePath = ""; 

    if (hour < 12) {
        greeting = 'Good Morning';
        imagePath = '/assets/svgs/morning-icon.svg'; 
    }
    else if (hour < 18) {
        greeting = 'Good Afternoon';
        imagePath = '/assets/svgs/afternoon-icon.svg';
    }
    else {
        greeting = 'Good Evening';
        imagePath = '/assets/svgs/evening-icon.svg';
    }

    document.getElementById(element_id).innerText = greeting + ", " + user_name + "!";
    document.getElementById('greeting-icon-image').src = imagePath; 
}

