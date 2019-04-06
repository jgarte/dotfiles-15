(use-modules (gnu)
             ((gnu packages admin) #:select (htop inetutils tree))
             ((gnu packages base) #:select (glibc-utf8-locales))
             ((gnu packages certs) #:select (nss-certs))
             ((gnu packages curl) #:select (curl))
             ((gnu packages emacs) #:select (emacs))
             ((gnu packages fonts)
              #:select (font-adobe-source-code-pro
                        font-fantasque-sans
                        font-iosevka
                        font-tamzen))
             ((gnu packages fontutils) #:select (fontconfig))
             ((gnu packages gnupg) #:select (gnupg))
             ((gnu packages linux) #:select (bluez))
             ((gnu packages lsof) #:select (lsof))
             ((gnu packages ncurses) #:select (ncurses))
             ((gnu packages shells) #:select (fish))
             ((gnu packages shellutils) #:select (fzy))
             ((gnu packages ssh) #:select (openssh))
             ((gnu packages terminals) #:select (termite))
             ((gnu packages tmux) #:select (tmux))
             ((gnu packages version-control) #:select (git))
             ((gnu packages vim) #:select (vim))
             ((gnu packages web-browsers) #:select (lynx))
             ((gnu packages xdisorg) #:select (rofi xcape))
             ((gnu services desktop)
              #:select (bluetooth-service
                        %desktop-services))
             ((gnu services dns)
              #:select (dnsmasq-service-type
                        dnsmasq-configuration))
             ((gnu services networking)
              #:select (network-manager-service-type
                        network-manager-configuration))
             ((gnu services pm)
              #:select (thermald-configuration
                        thermald-service-type
                        tlp-configuration
                        tlp-service-type))
             ((gnu services shepherd)
              #:select (shepherd-service
                        shepherd-service-type))
             ((gnu services ssh)
              #:select (openssh-service-type
                        openssh-configuration))
             ((gnu services xdisorg)
              #:select (xcape-configuration
                        xcape-service-type))
             ((gnu services xorg)
              #:select (gdm-service-type
                        gdm-configuration
                        xorg-configuration))
             (guix gexp)
             ((xmobar) #:select (xmobar-plus))
             ((xmonad) #:select (my-ghc-xmonad-contrib my-xmonad))
             ((yaft) #:select (yaft)))

(define cst-trackball
  "Section \"InputClass\"
    Identifier \"CST Trackball\"
    Driver \"libinput\"
    MatchVendor \"CST\"
    MatchProduct \"CST USB UNITRAC\"
    MatchIsPointer \"on\"
    Option \"AccelerationNumerator\" \"2.0\"
EndSection")

(define ctrl-nocaps (keyboard-layout "us" #:options '("ctrl:nocaps")))

(operating-system
 (host-name "ecenter")
 (timezone "America/Los_Angeles")
 (locale "en_US.utf8")
 (keyboard-layout ctrl-nocaps)
 (initrd-modules %base-initrd-modules)
 (bootloader
  (bootloader-configuration
   (bootloader grub-efi-bootloader)
   (target "/boot/efi")
   (keyboard-layout ctrl-nocaps)
   (menu-entries
    `(,(menu-entry
        (label "ubuntu")
        (linux "/boot/vmlinuz-4.15.0-43-generic")
        (linux-arguments
         '("root=UUID=45658f04-8790-437f-9590-13025ffb7264"
           "ro"
           "quiet"
           "splash"
           "vt.handoff=1"))
        (initrd "/boot/initrd.img-4.15.0-43-generic"))))))
 (file-systems
  (cons* (file-system
          (device
           (uuid "462563db-3f82-44d2-829c-eb2bce9fd0e0" 'ext4))
          (mount-point "/")
          (type "ext4"))
         (file-system
          (device (uuid "60E8-6B6F" 'fat))
          (mount-point "/boot/efi")
          (type "vfat"))
         (file-system
          (device
           (uuid "f9a82763-0828-4f4a-b668-9bf6008bf482" 'ext4))
          (mount-point "/mnt/sdcard")
          (type "ext4"))
         %base-file-systems))
 (swap-devices '("/dev/sda7"))
 (users
  (cons (user-account
         (name "john")
         (comment "idiot man")
         (group "users")
         (supplementary-groups
          '("wheel" "netdev" "audio" "video" "lp"))
         (home-directory "/home/john")
         (shell #~(string-append #$fish "/bin/fish")))
        %base-user-accounts))
 (packages
  (cons*
   ;; nice tty font
   font-tamzen
   ;; kmscon fonts
   fontconfig font-fantasque-sans font-iosevka
   ;; window manager related
   my-xmonad my-ghc-xmonad-contrib xmobar-plus rofi
   ;;for HTTPS access
   curl nss-certs
   ;; essentials
   lsof inetutils git fish openssh gnupg htop ncurses tmux fzy lynx
   tree yaft glibc-utf8-locales
   ;; text editors
   vim emacs
   ;; for keyboards
   bluez
   %base-packages))
 (services
  (cons*
   ;; TODO: Add service for modprobe.d modules?
   (bluetooth-service #:auto-enable? #t)
   (service dnsmasq-service-type
            (dnsmasq-configuration
             (servers '("1.1.1.1"))))
   ;; (service xcape-service-type
   ;;          (xcape-configuration
   ;;           "john"
   ;;           '(("Control_L" . "Escape"))))
   (service kmscon-service-type
            (kmscon-configuration
             (virtual-terminal "tty8")
             (scrollback "100000")
             (font-name "'Fantasque Sans Mono'")
             (font-size "15")
             (xkb-layout "us")
             (xkb-variant "")
             (xkb-options "ctrl:nocaps")))
   (service openssh-service-type
            (openssh-configuration
             (challenge-response-authentication? #f)
             (password-authentication? #f)))
   (service thermald-service-type
            (thermald-configuration))
   (service tlp-service-type
            (tlp-configuration
             (tlp-default-mode "BAT")
             (usb-autosuspend? #f)))
   (modify-services
    %desktop-services
    ('console-font-service-type
     s =>
     `(("tty1" "LatGrkCyr-8x16")
       ("tty2" "TamzenForPowerline8x16b")
       ("tty3" "LatGrkCyr-8x16")
       ("tty4" "LatGrkCyr-8x16")
       ("tty5" "LatGrkCyr-8x16")
       ("tty6" "LatGrkCyr-8x16")))
    ('network-manager-service-type
     c =>
     (network-manager-configuration
      (inherit c)
      (dns "none")))
    ('gdm-service-type
     c =>
     (gdm-configuration
      (inherit c)
      (auto-login? #t)
      (default-user "john")
      (xorg-configuration
       (xorg-configuration
        (keyboard-layout ctrl-nocaps)
        (extra-config `(,cst-trackball)))))))))
 ;; Allow resolution of '.local' host names with mDNS.
 (name-service-switch %mdns-host-lookup-nss))
