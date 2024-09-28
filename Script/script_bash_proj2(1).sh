#!/bin/bash

######################### https://github.com/RehanSaeed/Bash-Cheat-Sheet ###################################
################################### liste de commandes bash ################################################
############################################################################################################
#######################################   action fonction   ################################################
############################################################################################################

#Vérification si l'utilisateur existe

#function user_exists () {
#    if cat /etc/passwd | grep $1
#        then
#            echo "Utilisateur $1 existe"
#            return 0
#    else
#        echo "Veuillez créer cette $1 dans le menu Gestion de compte."
#        return 1
#    fi
#}

#Création de compte utilisateur local avec mot de passe :

function create_user () {
    read -p "Entrez le nom de l'utilisateur a créer :" user
    if ssh $utilisateur@$ip "cat /etc/passwd | grep "$user""
        then
        echo "L'ustilisateur $user existe"
    else
        ssh $utilisateur@$ip "sudo -S useradd $user"
            echo "utilisateur $user créé"
            return 0
    fi
}

#ajouter un mot de passe :

function add_Mdp () {
    read -p "Entrez le nom d'utilisateur a ajouter un mot de passe :" add_MDP_user
    ssh $utilisateur@$ip "sudo -S passwd $add_MDP_user"
    sleep 2
    echo "ajout de mot de passe reussi"
}



#Changement de mot de passe :

function changeMDP() {
    read -p "Entrer l'utilisateur" 1
    if ssh $utilisateur@$ip "sudo -S passwd "$1""; then
        echo "modification mot de passe réussi"
        return 0
    else
        echo "Échec de la modification."
        return 1 
    fi
}


#Suppression de compte utilisateur local :

function del_user () {
    read -p "Entrez le nom d'utilisateur à supprimer : " suppr_user
    sleep 1
    read -p "Voulez-vous vraiment supprimer le compte utilisateur $suppr_user ? (O/N)" delrep
    ssh $utilisateur@$ip "sudo -S deluser $suppr_user"
    sleep 3
    # si reponse de confirmation est egale a O 
    if [ "$delrep" == "O" ]
        then
            echo "suppression $suppr_user réussi"
            return 0
    else
            echo "Suppression echoué"
            return1
    fi

}

#Activation de compte utilisateur local :

function activ_User () {
 read -p "Entrer le nom d'utilisateur a activer :" activer_user
    if ssh $utilisateur@$ip  "id "$activer_user" &>/dev/null"; 
        then
        # Vérifie si l'utilisateur est déjà activé
        # l'option -S demande des informations sur le mot de passe
        #l'option -q naffichera pas le resultats de la recherhce
        # la lettre 'P' est utilisée pour vérifier l'état du mot de passe
        if ssh $utilisateur@$ip "sudo -S passwd -S "$activer_user" | grep -q 'P'"; then
            echo "L'utilisateur $activer_user est déjà activé !"
            return 1
        else
            # Active l'utilisateur
            ssh $utilisateur@$ip "sudo -S usermod -U "$activer_user""
            echo "Activation de l'utilisateur $activer_user réussie."
            return 0
        fi
    else
        echo "L'utilisateur $activer_user n'existe pas."
        return 1
    fi
}

#Désactivation de compte utilisateur local :

function desactiv_User () {
    read -p "Entrer le nom d'utilisateur a désactiver :" desactiver_user
    # l'option -S demande des informations sur l'utilisateur
    if ssh $utilisateur@$ip "sudo -S passwd -S $desactiver_user"
        then
            echo "l'$desactiver_user est déjà désactivé !"
            return 1
    else
            #-L l'option qui verrouille le compte
            ssh $utilisateur@$ip "sudo -S usermod -L $desactiver_user"
            echo "désactivation $desactiver_user réussi"
            return 0
    fi

}

#Ajout à un groupe d'administrateur :
#-nG affiche les noms de tous les groupes auxquels appartient l'utilisateur
function add_admin () {
    read -p "Entrer le nom d'utilisateur a ajouter en administrateur :" admin_add_user
    #l'option -nG pour afficher uniquement les noms des groupes et 
    # -qw Mode silencieux et s'assure qu'il es un mot entier
    if ssh $utilisateur@$ip  "id -nG $admin_add_user| grep -qw sudo"
        then
        echo "Cette utilisateur est déja dans le groupe administrateur."
        return 1
    else
        # l-option -a ajoute au -G groupe indiqué apres
        ssh $utilisateur@$ip "sudo -S usermod -aG sudo $admin_add_user"
        echo "ajout de $admin_add_user en tant que administrateur"
        return 0
    fi
}

#Ajout à un groupe local :

function add_Grp_local () {
    read -p "Entrer le nom d'utilisateur a ajouter au groupe local :" user_add_grp
    # l'option -nG pour afficher uniquement les noms groupes
    if ssh $utilisateur@$ip "id -nG $user_add_grp | grep -qw users "
        then
        echo "Cette utilisateur est déjà dans le groupe local"
        return 1
    else
    # l-option -a ajoute au -G groupe indiqué apres
        ssh $utilisateur@$ip "sudo -S usermod -aG users $user_add_grp"
        echo "ajout de $user_add_grp au groupe local"
        return 0
    fi
}

#Sortie d'un groupe local :

function sortie_Grp_local () {
    read -p "Entrer le nom d'utilisateur a sortir du groupe local :" leave_grp
    # l'option -nG pour afficher uniquement les noms groupes
    if ssh $utilisateur@$ip "! ( id -nG $leave_grp | grep -qw users )"
        then
        echo "Cette utilisateur n'est pas dans le groupe local"
        return 0
    else
        ssh $utilisateur@$ip "sudo -S deluser $leave_grp "nom de groupe""
        echo "sortie de $leave_grp du groupe local"
        return 0
    fi
}

#Arrêt de l'ordinateur :

function stop_ordi () {
    echo "Arrêt de l'ordinateur client"
    sleep 3
    # l'option -h indique a la commande d'arreter le systeme l'option now maintenant
    ssh $utilisateur@$ip "sudo -S shutdown -h now"
    return 0
}

#Redémarrage de l'ordinateur :

function restart_ordi () {
    echo "L'ordinateur va redémarrer"
    sleep 3
    ssh $utilisateur@$ip "sudo -S reboot"
    return 0
}

#Verrouillage de l'ordinateur :

function verrouiller_ordi () {
    echo "L'ordinateur va être en veille"
    sleep 3
    ssh $utilisateur@$ip "sudo -S systemctl suspend"   
    return 0
}

#Mise à jour du système :

function maj_systeme () {
    echo "Mise à jour du système lancé"
    sleep 3
    ssh $utilisateur@$ip "sudo -S apt update && sudo apt upgrade -y"
    return 0
}

#Création de répertoire :

function create_directory () {
    read -p "Entrez le nom du dossier a créer :" create_dossier
    ssh $utilisateur@$ip "mkdir $create_dossier"
    echo "creation du repertoire"
    return 0
}

#Modification de répertoire :

function modify_directory () {
    read -p "Entrez le nom de dossier a modifier : " mod_dossier
    if ssh $utilisateur@$ip "mv $mod_dossier #<nouveau nom>"
        then
            echo "modification du répertoire"
        return 0
    else
        echo "le dossier $mod_dossier n'existe pas!"
        return 1
    fi
}

#Suppression de répertoire :

function del_directory () {
    real -p "Entrez le nom du dossier a supprimé :" del_dossier
    ssh $utilisateur@$ip "rm -r del_dossier"
    sleep 2
    echo "suppression du répertoire"
    return 0
}

#Prise de main à distance de l'ordinateur client :

function  prise_main_distance () {
    ssh $utilisateur@$ip
    exit 0
}

#Activation du pare-feu :

function activer_pare_feu () {
    ssh $utilisateur@$ip "sudo -S ufw enable"
    echo "activation du pare-feu"
    exit 0
}

#Désactivation du pare-feu :

function desactiver_pare_feu () {
    ssh $utilisateur@$ip "sudo -S ufw disable"
    echo "désactivation du pare-feu"
    exit 0
}

#Ajouter un logiciel :

function inst_software () {
    read -p "Entrer le nom du logiciel a installer :" name_software
    echo "Installation de $name_software lancé"
    sleep 1
    ssh $utilisateur@$ip "sudo -S apt install $name_software"
    return 0
}

function del_software () {
    read -p "Entrer le nom du logiciel a désinstaller :" supp_software
    echo "Désnstallation de $supp_software lancé"
    ssh $utilisateur@$ip "sudo -S apt-get --purge remove $supp_software"
    return 0
}
############################################################################################################
#####################################   information fonction   #############################################
############################################################################################################
#Date de dernière connexion de l'utilisateur :

function date_derniere_connexion () {
    read -p "Entrez le nom d'utilisateur :" lastlog_user
    echo "Affiche la date de dernière connexion de lastlog $lastlog_user"
    ssh $utilisateur@$ip "sudo -S lastlog $lastlog_user"
    return 0
}

#Date de dernière modification du mot de passe :

function date_derniere_modif_mot_de_passe () {
    read -p "Entrez le nom d'utilisateur :" lastmodif_user
    echo "Affiche la date de dernière modification du mot de passe."
    ssh $utilisateur@$ip "chage -l $lastmodif_user"
    return 0
}

#    Liste des sessions ouvertes par l'utilisateur :

function liste_sessions_utilisateur () {
    ################################################################a revoir###########################################################################
    read -p "Entrez le nom d'utilisateur :" user_session
    echo "Affiche la liste des sessions ouvertes par l'utilisateur"
    ssh $utilisateur@$ip "w -u $user_session"
    return 0
}

#    Groupe d'appartenance d'un utilisateur :

function groupe_appartenance_utilisateur () {
    read -p "Entrez le nom d'utilisateur :" grp_user
    if ssh $utilisateur@$ip "groups $grp_user"
        then
            echo "Affiche le groupe d'appartenance de $grp_user"
        return 0
    else
            echo "Impossible d' afficher le groupe d'appartenance de $grp_user"
        return 1
    fi
}

#    Historique des commandes exécutées par l'utilisateur :

function history_cmd_User () { 
    if ssh $utilisateur@$ip "history"
        then
            echo "Affichage de l'historique des commandes exécutées par l'utilisateur"
        return 0
    else
        echo "impossible d'afficher l'historique"
        return 1
    fi
}

#Droits et permissions de l'utilisateur sur un dossier :

function droits_permissions_dossier () {
    read -p "Entrez le chemin du dossier, ex: /home/user/repertoire/dossier" road_directory
    if ssh $utilisateur@$ip "ls -ld $road_directory"
        then
            echo "Affiche les droits et permissions de l'utilisateur sur le dossier"
            return 0
    else
            echo "Impossible de verifier! Assurez vous que le chemin est correct."
            return 1
    fi
}

#    Droits et permissions de l'utilisateur sur un fichier :

function droits_permissions_fichier () {
    read -p "Entrez le chemin du fichier, ex: /home/user/directory/file.txt" road_file
    if ssh $utilisateur@$ip  "ls -ld $road_file"
        then
            echo "Affiche les droits et permissions de l'utilisateur sur le fichier"
            return 0
    else
            echo "Impossible de verifier! Assurez vous que le chemin est correct."
            return 1
    fi
}

#Version de l'OS de l'ordinateur client :

function version_os () {
    if ssh $utilisateur@$ip  "lsb_release -a"
        then 
            echo "Affichage de la version de l'os du client"
            return 0
    else
            echo "Impossible d'afficher l'OS"
            return 1
    fi
}

#Nombre de disques de l'ordinateur client :

function nombre_disques () {
    if ssh $utilisateur@$ip "lsblk | grep disk | wc -l"
        then
            echo "Affiche le nombre de disque du client"
            return 0
    else
            echo "Impossible d'afficher le nombre de disque"
            return 1
    fi
}

#Partition par disque de l'ordinateur client :

function partition_par_disque () {
    if ssh $utilisateur@$ip "lsblk | grep sd"
        then
            echo "Affichage des informations sur les partitions par disque du client"
            return 0
    else
            echo "Impossible d'afficher"
            return 1
    fi
}

#Nom et espace disque d'un dossier :

function espace_disque_dossier () {
    ssh $utilisateur@$ip "df -h #/chemin/du/dossier"
    echo "Affiche le nom et l'espace disque du dossier"
    exit 0
}

#Liste des lecteurs montés :

function lecteurs_montes () {
    ssh $utilisateur@$ip "df -h"
    echo "Affiche le liste des lecteurs montés"
    exit 0
}

#Nombre d'interfaces et adresse ip :

function interfaces_ip () {
    ssh $utilisateur@$ip "sudo -S netstat -i | --interfaces && ip addr" #a verifier 
    echo "Affiche le nombre d'interfaces et leur adresse ip"
    exit 0
}

#Liste des ports ouverts :

function ports_ouverts () {
    ssh $utilisateur@$ip "sudo netstat -l | --listening && ip addr"
    echo "Affiche la liste des ports ouverts"
    exit 0
}

#Statut du pare-feu :



function statut_pare_feu () {
    ssh $utilisateur@$ip "sudo -S ufw status"
    echo "Affiche le statut du pare-feu"
    exit 0
}

#Recherche des événements dans le fichier log_evt.log pour un utilisateur :

function recherche_evenements_utilisateur () {
    ssh $utilisateur@$ip "grep "nom_user" #/chemin/dufichier/log_evt.log"
    echo "Affiche es evenements du fichier log_evt.log pour un utilisateur"
    exit 0
}

#Recherche des événements dans le fichier log_evt.log pour un ordinateur :

function recherche_evenements_ordinateur () {
    ssh $utilisateur@$ip "grep "adresse_ip" #/chemin/dufichier/log_evt.log"
    echo "Affiche les événements du fichier log_evt.log pour un ordinateur"
    exit 0
}

function optionGestion()
{
    echo "choisir un option"
    echo "1. menu de gestion"
    echo "2. gestion compte"
    echo "3. gestion groupe"
    echo "4. gestion systeme"
    echo "5. gestion repertoire"
    echo "6. gestion securité"
    echo "7. gestion logiciel"
    echo "8. gestion bureau a distance"
}

function optionInformation()
{
    echo "choisir un option"
    echo "1. information utilisateur"
    echo "2. information système client"
}
#menu gestion ou information

 while true; do
    optionGestion
    read -p "Inserer le numéro de l'option : " choix
    read -p "Ip" ip
    read -p "user" utilisateur

    case $choix in
        1)  
            echo "Vous avez choisi la gestion de compte."
            # Boucle pour afficher le sous-menu de gestion de compte
            while true; do
                echo "Menu gestion de compte :"
                echo "1. Créer un utilisateur"
                echo "2. Changer le mot de passe d'un utilisateur"
                echo "3. Supprimer un utilisateur"
                echo "4. Désactiver un compte utilisateur"
                echo "5. Ajouter à un groupe d'administrateur"
                echo "6. Ajouter à un groupe local"
                echo "7. Sortir d'un groupe local"
                echo "8. Revenir au menu principal"
                read -p "Choix : " gestCompte

                case $gestCompte in
                    1)  
                        create_user
                        # Ajouter code créer un utilisateur
                        ;;
                    2)  
                        changeMDP
                        # Ajouter code changer le mot de passe
                        ;;
                    3)  
                        del_user
                        # Ajouter code supprimer un utilisateur
                        ;;
                    4)  
                        desactiv_User
                        # Ajouter code désactiver un compte utilisateur
                        ;;
                    5)  
                        add_admin
                        # Ajouter code ajout à un groupe d'administrateur
                        ;;
                    6)  
                        add_Grp_local
                        # Ajouter code ajout à un groupe local
                        ;;
                    7)  
                        sortie_Grp_local
                        # Ajouter code sortir d'un groupe local
                        ;;
                    8)  
                        echo "Retour au menu principal"
                        break  # Sortir de la boucle interne
                        ;;
                    *)  
                        echo "Option invalide. Veuillez choisir une option valide."
                        ;;
                esac
            done
            ;;
        2)  
            echo "Vous avez choisi la gestion système."
            # Boucle pour afficher le sous-menu de gestion système
            while true; do
                echo "Menu gestion de système :"
                echo "1. arrêt de l'ordinateur"
                echo "2. redémarrage"
                echo "3. verrouillage"
                echo "4. mise-à-jour du système"
                echo "5. création de répertoire"
                echo "6. modification de répertoire"
                echo "7. suppression de répertoire"
                echo "8. activation du pare-feu"
                echo "9. désactivation du pare-feu"
                echo "10. installation de logiciel"
                echo "11. désinstallation de logiciel"
                echo "12. Revenir au menu principal"
                read -p "Choix : " gestSystem

                case $gestSystem in
                    1)  
                        stop_ordi
                        # Ajouter code arrêt de l'ordi
                        ;;
                    2)  
                        restart_ordi
                        # Ajouter code redémarrage
                        ;;
                    3)  
                        verrouiller_ordi
                        # Ajouter code verrouillage
                        ;;
                    4)  
                        maj_systeme
                        # Ajouter code maj du système
                        ;;
                    5)  
                        create_directory
                        # Ajouter code création de répertoire
                        ;;
                    6)  
                        modify_directory
                        # Ajouter code modification répertoire
                        ;;
                    7)  
                        del_directory
                        # Ajouter code suppression de répertoire
                        ;;
                    8)  
                        activer_pare_feu
                        # Ajouter code activation du pare-feu 
                        ;;
                    9)  
                        desactiver_pare_feu
                        # Ajouter code Désactivation du pare-feu
                        ;;
                    10)
                        inst_software
                        # Ajouter code installation de logiciel
                        ;;
                    11)
                        del_software
                        # Ajouter code désinstallation de logiciel
                        ;;
                    12)
                        echo "12. Revenir au menu principal"
                        break
                        ;;
                    *)
                        echo "Option invalide. Veuillez choisir une option valide."
                        ;;
                esac
            done
            ;;
        3)  
            echo "Vous avez choisi gestion des informations utilisateur."
            while true; do
                echo "Menu gestion des informations :"
                echo "1. Date de dernière connexion d'un utilisateur"
                echo "2. Date de dernière modification du mot de passe"
                echo "3. Liste des sessions ouvertes par l'utilisateur"
                echo "4. Groupe d'appartenance d'un utilisateur"
                echo "5. Historique des commandes exécutées par l'utilisateur"
                echo "6. Droits/permissions de l'utilisateur sur un dossier"
                echo "7. Droits/permissions de l'utilisateur sur un fichier"
                echo "8. Revenir au menu principal"
                read -p "Choix : " infUser

                case $infUser in
                    1)  
                        echo "1. Date de dernière connexion d'un utilisateur"
                        # Ajouter code date dernière connexion utilisateur
                        ;;
                    2)  
                        echo "2. Date de dernière modification du mot de passe"
                        # Ajouter code date dernière modification du Mdp
                        ;;
                    3)  
                        echo "3. Liste des sessions ouvertes par l'utilisateur"
                        # Ajouter code liste sessions ouvertes
                        ;;
                    4)  
                        echo "4. Groupe d'appartenance d'un utilisateur"
                        # Ajouter code Grp appartenance utilisateur
                        ;;
                    5)  
                        echo "5. Historique des commandes exécutées par l'utilisateur"
                        # Ajouter code historique commandes exécutées par utilisateur
                        ;;
                    6)  
                        echo "6. Droits/permissions de l'utilisateur sur un dossier"
                        # Ajouter code D/P utilisateur sur dossier
                        ;;
                    7)  
                        echo "7. Droits/permissions de l'utilisateur sur un fichier"
                        # Ajouter code D/P utilisateur sur un fichier
                        ;;
                    8)  
                        echo "8. Revenir au menu principal"
                        break
                        # Ajouter code activation du pare-feu 
                        ;;
                    *)
                        echo "Option invalide. Veuillez choisir une option valide."
                        ;;
                esac
            done
            
            ;;
        4)  
            echo "Vous avez choisi la gestion des informations ordinateur client"
            # 
             while true; do
                echo "Menu gestion des informations ordinateur client :"
                echo "1. Version de l'OS"
                echo "2. Nombre de disque"
                echo "3. Partition par disque"
                echo "4. Espace disque restant par partition/volume"
                echo "5. Nom et espace disque d'un dossier"
                echo "6. Liste des lecteurs montés"
                echo "7. Nombre d'interface"
                echo "8. Adresse IP de chaque interface"
                echo "9. Adresse Mac"
                echo "10. Liste des ports ouverts"
                echo "11. Statut du pare-feu"
                echo "12. Revenir au menu principal"
                read -p "Choix : " postInfCli

                case $postInfCli in
                    1)  
                        echo "1. Version de l'OS"
                        # Ajouter code version OS
                        ;;
                    2)  
                        echo "2. Nombre de disque"
                        # Ajouter code Nbr disk
                        ;;
                    3)  
                        echo "3. Partition par disque"
                        # Ajouter code partition par disk
                        ;;
                    4)  
                        echo "4. Espace disque restant par partition/volume"
                        # Ajouter code espace disk restant
                        ;;
                    5)  
                        echo "5. Nom et espace disque d'un dossier"
                        # Ajouter code nom et espace disk dossier
                        ;;
                    6)  
                        echo "6. Liste des lecteurs montés"
                        # Ajouter code liste lecteurs montés
                        ;;
                    7)  
                        echo "7. Nombre d'interface"
                        # Ajouter code Nbr interface
                        ;;
                    8)  
                        echo "8. Adresse IP de chaque interface"
                        # Ajouter code adresse IP chaque interface
                        ;;
                    9)  
                        echo "9. Adresse Mac"
                        # Ajouter code adresse Mac
                        ;;
                    10)
                        echo "10. Liste des ports ouverts"
                        # Ajouter code liste des ports
                        ;;
                    11)
                        echo "11. Statut du pare-feu"
                        # Ajouter code stat pare-feu
                        ;;
                    12)
                        echo "12. Revenir au menu principal"
                        break
                        ;;
                    *)
                        echo "Option invalide. Veuillez choisir une option valide."
                        ;;
                esac
            done
            ;;
        5)
            echo "Vous avez choisi la recherche des evenements"
                 while true; do
                echo "Menu gestion des recherches evenements sur fichier log_evt.log:"
                echo "1. Recherche pour un utilisateur"
                echo "2. Recherche pour un ordinateur"
                echo "3. Revenir au menu principal"
                read -p "Choix : " rech_even

                case $rech_even in
                    1)  
                        echo "1. Recherche pour un utilisateur"
                        # Ajouter code recherche
                        ;;
                    2)  
                        echo "2. Recherche pour un ordinateur"
                        # Ajouter code recherche
                        ;;
                    3)
                        echo "3. Revenir au menu principal"
                        break
                        ;;
                    *)
                        echo "Option invalide. Veuillez choisir une option valide."
                        ;;
                esac 
               done
            ;;
        6)  
            echo "Au revoir !"
            exit 0
            ;;
        *)  
            echo "Choix non valide. Veuillez choisir une option valide."
            ;;
    esac
done

