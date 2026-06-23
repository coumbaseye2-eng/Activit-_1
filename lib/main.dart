import 'package:flutter/material.dart';

void main() {
  runApp(const MonAppli());
}

class MonAppli extends StatelessWidget {
  const MonAppli({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Magazine',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const PageAccueil(),
    );
  }
}

class PageAccueil extends StatelessWidget {
  const PageAccueil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Magazine Infos'),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
       body: const SingleChildScrollView(
        child: Column(
          children: [
            Image(
              image: AssetImage('assets/images/mag_inf.png'),
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            PartieTitre(),
            PartieTexte(),
            PartieIcone(),
            PartieRubrique(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        onPressed: () {
          print('Tu as cliqué dessus');
        },
        child: const Text('click', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

class PartieTitre extends StatelessWidget {
  const PartieTitre({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bienvenue sur notre magazine d\'informations',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'Dakar, Sénégal',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class PartieTexte extends StatelessWidget {
  const PartieTexte({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        'Ici, vous trouverez les dernières nouvelles, articles inspirants et reportages exclusifs sur divers sujets captivants.',
        style: TextStyle(fontSize: 16, height: 1.4),
        textAlign: TextAlign.justify,
      ),
    );
  }
}
class PartieIcone extends StatelessWidget {
  const PartieIcone({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _construireBoutonAction(Icons.phone, 'TEL', Colors.blueAccent),
          _construireBoutonAction(Icons.near_me, 'ROUTE', Colors.blueAccent),
          _construireBoutonAction(Icons.share, 'PARTAGE', Colors.blueAccent),
        ],
      ),
    );
  }
  Widget _construireBoutonAction(IconData icone, String libelle, Color couleur) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icone, color: couleur, size: 26),
        const SizedBox(height: 8),
        Text(
          libelle,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: couleur),
        ),
      ],
    );
  }
}
class PartieRubrique extends StatelessWidget {
  const PartieRubrique({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        childAspectRatio: 1.3,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: const Image(
              image: AssetImage('assets/images/Dev_mob.png'),
              fit: BoxFit.cover,
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: const Image(
              image: AssetImage('assets/images/equipe.png'),
              fit: BoxFit.cover,
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: const Image(
              image: AssetImage('assets/images/collab.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: const Image(
              image: AssetImage('assets/images/voilée_tech.png'),
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}