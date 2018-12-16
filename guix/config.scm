(use-modules (gnu)
             ((gnu packages admin) #:select (htop inetutils))
             ((gnu packages base) #:select (glibc-utf8-locales))
             ((gnu packages certs) #:select (nss-certs))
             ((gnu packages emacs) #:select (emacs))
             ((gnu packages fonts) #:select (font-tamzen))
             ((gnu packages gnupg) #:select (gnupg))
             ((gnu packages lsof) #:select (lsof))
             ((gnu packages ncurses) #:select (ncurses))
             ((gnu packages shells) #:select (fish))
             ((gnu packages ssh) #:select (openssh))
             ((gnu packages terminals) #:select (termite))
             ((gnu packages tmux) #:select (tmux))
             ((gnu packages version-control) #:select (git))
             ((gnu packages vim) #:select (vim))
             ((gnu packages xdisorg) #:select (rofi))
             ((gnu services desktop) #:select (bluetooth-service %desktop-services))
             ((gnu services pm) #:select (thermald-configuration
                                          thermald-service-type
                                          tlp-configuration
                                          tlp-service-type))
             ((gnu services ssh) #:select (openssh-service-type))
             ((xmobar) #:select (xmobar-plus))
             ((xmonad) #:select (my-ghc-xmonad-contrib my-xmonad)))

(define cst-trackball
  "Section \"InputClass\"
    Identifier \"CST Trackball\"
    Driver \"libinput\"
    MatchVendor \"CST\"
    MatchProduct \"CST USB UNITRAC\"
    MatchIsPointer \"on\"
    Option \"AccelerationNumerator\" \"2.0\"
EndSection")

(operating-system
 (host-name "ecenter")
 (timezone "America/Los_Angeles")
 (locale "en_US.utf8")
 (initrd-modules %base-initrd-modules)
 (bootloader (bootloader-configuration
              (bootloader grub-efi-bootloader)
              (target "/boot/efi")))
 (file-systems (cons* (file-system
                       (device (uuid "462563db-3f82-44d2-829c-eb2bce9fd0e0" 'ext4))
                       (mount-point "/")
                       (type "ext4"))
                      (file-system
                       (device (uuid "60E8-6B6F" 'fat))
                       (mount-point "/boot/efi")
                       (type "vfat"))
                      %base-file-systems))
 (swap-devices '("/dev/sda7"))
 (users (cons (user-account
               (name "john")
               (comment "idiot man")
               (group "users")
               (supplementary-groups '("wheel"
                                       "netdev"
                                       "audio"
                                       "video"
                                       "lp"))
               (home-directory "/home/john")
               ;; TODO: Figure out fish environmnet issues.
               ;; (shell #~(string-append #$fish "/bin/fish"))
               )
              %base-user-accounts))
 (packages (cons*
            ;; nice tty font
            font-tamzen
            ;; window manager related
            my-xmonad
            my-ghc-xmonad-contrib
            xmobar-plus
            rofi
            ;;for HTTPS access
            nss-certs
            ;; essentials
            lsof
            inetutils
            git
            fish
            openssh
            gnupg
            htop
            ncurses
            tmux
            glibc-utf8-locales
            ;; text editors
            vim
            emacs
            %base-packages))
 (services (cons*
            ;; TODO: Add service for modprobe.d modules?
            (bluetooth-service #:auto-enable? #t)
            (console-keymap-service "/home/john/dotfiles/minimal/Caps2Ctrl.map")
            (service kmscon-service-type
                     (kmscon-configuration (virtual-terminal "tty8")))
            (service openssh-service-type)
            (service thermald-service-type (thermald-configuration))
            (service tlp-service-type
                     (tlp-configuration
                      (tlp-default-mode "BAT")
                      (usb-autosuspend? #f)))
            (modify-services
             %desktop-services
             ('console-font-service-type
              s =>
              (list
               '("tty1" "LatGrkCyr-8x16")
               '("tty2" "TamzenForPowerline8x16")
               '("tty3" "LatGrkCyr-8x16")
               '("tty4" "LatGrkCyr-8x16")
               '("tty5" "LatGrkCyr-8x16")
               '("tty6" "LatGrkCyr-8x16")))
             ('slim-service-type
              c =>
              (slim-configuration
               (inherit c)
               (startx (xorg-start-command
                        #:configuration-file
                        (xorg-configuration-file
                         #:extra-config
                         (list cst-trackball)))))))))
 ;; Allow resolution of '.local' host names with mDNS.
 (name-service-switch %mdns-host-lookup-nss))

