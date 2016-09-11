#!/bin/bash

case $(hostname) in
  r407pc0* | r407pc1* | r408pc0* | r408pc1* )
    x11vnc -auth guess -display :0 forever > /var/log/vnc-server.log
  ;;
  *)
  ;;
esac

exit 1
