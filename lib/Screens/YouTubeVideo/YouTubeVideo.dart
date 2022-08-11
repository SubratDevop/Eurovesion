import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


class YouTube extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: YouTubeScreen(),
    );
  }
}

class YouTubeScreen extends StatefulWidget {
  const YouTubeScreen({ Key? key }) : super(key: key);

  @override
  _YouTubeScreenState createState() => _YouTubeScreenState();
}

class _YouTubeScreenState extends State<YouTubeScreen> {

  String  videoid = "urrJ0PnIzc0";
  late YoutubePlayerController  mYoutubePlayerController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    mYoutubePlayerController=
    YoutubePlayerController(
      //initialVideoId: YoutubePlayer.getThumbnail(videoId: "IQPNJHCppN4"),
       initialVideoId: videoid, 
       flags: const YoutubePlayerFlags(autoPlay: true, mute: false)
    );
  }

  @override
  Widget build(BuildContext context) {

    double width= MediaQuery.of(context).size.width;
    double height= MediaQuery.of(context).size.height;

    return YoutubePlayerBuilder(
      player: YoutubePlayer(controller: mYoutubePlayerController),
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Youtube Video Player"),
          ),
          body: Container(
            child: player,
          ),
        );
      },
    );
  }
}