size(500, 500);

background(
61, 147, 212
);

fill(255, 208, 54);
noStroke();
ellipse(200, 130, 200, 200);

stroke(255);
strokeWeight(8);
fill(0);
ellipse(150, 100, 30, 30);
ellipse(250, 100, 30, 30);

stroke(0);
strokeWeight(1);
noFill();
arc(200, 150, 70, 70, QUARTER_PI, PI-QUARTER_PI);

stroke(255);
strokeWeight(2);
fill(255, 85);
rect(120, 75, 60, 50);
rect(220, 75, 60, 50);

line(180, 100, 220, 100);

noStroke();
fill(219, 126, 242);
rect(100, 250, 200, 300);
rect(30, 250, 50, 300);
rect(325, 250, 50, 300);

save("portrait.jpg");
