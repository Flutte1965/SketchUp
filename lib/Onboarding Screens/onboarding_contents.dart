class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents({
    required this.title,
    required this.image,
    required this.desc,
  });
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "Bring Your Vision to Life",
    image: "assets/images/main logo.png",
    desc: "Step into the Future of interior design with AR. Capture, Customize and create your perfect space effortlessly." ),

  OnboardingContents(
    title: "Capture & Customize ",
    image: "assets/images/onb page2.png",
    desc:
        "Snap picture of furniture with your camera, remove backgrounds and seamlessly integrate them into your designs." ),
  OnboardingContents(
    title: "Design, Arrange & Save ",
    image: "assets/images/onb page3.png",
    desc: "Drag, Drop and arrange captured items to perfect your space, Save and share your creations with a single tap",
  ),
];
