# Déploiement d'une Infrastructure Cloud avec Terraform et Outscale

Ce projet détaille le déploiement d'une infrastructure cloud sécurisée et évolutive en utilisant **Terraform** et **Outscale**. Il couvre la création d'un **Virtual Private Cloud (VPC)**, de sous-réseaux publics et privés, une machine bastion, des serveurs web, et un Load Balancer pour assurer la haute disponibilité.

---

## **Fonctionnalités**
1. **Réseau (VPC et sous-réseaux)** :
   - Un réseau privé virtuel avec isolation complète.
   - Sous-réseau public pour la bastion et le Load Balancer.
   - Sous-réseau privé pour les serveurs web protégés.

2. **Machine Bastion** :
   - Point d’entrée sécurisé pour administrer les serveurs privés.
   - Accessible uniquement via SSH depuis une IP autorisée.

3. **Serveurs Web** :
   - Deux serveurs web dans un sous-réseau privé.
   - Application déployée automatiquement avec **Cloud-init**.

4. **Load Balancer** :
   - Répartit le trafic entre les serveurs web.
   - Vérifications de santé pour garantir la disponibilité.

5. **Sécurité** :
   - Groupes de sécurité configurés pour limiter les accès.
   - Connexions SSH, HTTP et HTTPS contrôlées.

---

## **Prérequis**
- **Terraform** : [Installation officielle](https://www.terraform.io/downloads.html)
- **Clés Outscale** : Accès au compte Outscale avec les clés d’API configurées.
- **Paire de clés SSH** : Pour accéder à la machine bastion.

---

## **Structure des Fichiers**
- `main.tf` : Définition des ressources Terraform (VPC, sous-réseaux, VM, Load Balancer).
- `variables.tf` : Déclaration des variables utilisées dans le projet.
- `terraform.tfvars` : Valeurs des variables sensibles (clés d’accès, noms, IP).
- `outputs.tf` : Définit les sorties importantes après déploiement (ex. : IP publiques, ID de ressources).

---

## **Instructions**

### **1. Configurer les Variables**
Dans `terraform.tfvars`, entrez vos valeurs :
```hcl
outscale_access_key = "votre_clé_d'accès"
outscale_secret_key = "votre_clé_secrète"
keypair_name        = "nom_de_votre_paire_de_clés"
allowed_ssh_ip      = "votre_IP_publique"
```

---

### **2. Initialiser le Projet**

Initialisez Terraform pour télécharger les plugins nécessaires :
```terraform init```

---

### **3. Générer un Plan**

Créez un plan d’exécution pour voir les ressources à déployer :
```terraform plan```

---

### **4. Appliquer le Plan**

Déployez l’infrastructure :
```terraform apply```

Confirmez avec yes lorsque demandé.

---

## **Tests**
    Machine Bastion :
	•	Connectez-vous via SSH: ssh -i <votre_clé.pem> outscale@<bastion_public_ip>

    Serveurs Web :
	•	Depuis la bastion, accédez aux serveurs privés via leur IP privée.
	Load Balancer :
	•	Accédez à l’adresse publique ou DNS du Load Balancer via un navigateur.
	•	Vérifiez la répartition du trafic entre les serveurs.

---