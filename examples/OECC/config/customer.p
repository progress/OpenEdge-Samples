USING Progress.Json.ObjectModel.JsonObject.

CREATE WIDGET-POOL.

{src/web2/wrap-cgi.i}

DEFINE TEMP-TABLE ttCustomer LIKE Customer.
DEFINE DATASET dsCustomer FOR ttCustomer.

RUN process-web-request.

PROCEDURE outputHeader :
  output-content-type ("application/json":U).
END PROCEDURE.

PROCEDURE process-web-request :
  DEFINE VARIABLE oJsonObject        AS Progress.Json.ObjectModel.JsonObject NO-UNDO.
  DEFINE VARIABLE lChar              AS LONGCHAR NO-UNDO.
  RUN outputHeader.

  EMPTY TEMP-TABLE ttCustomer.
  FOR EACH Customer WHERE Customer.CustNum < 3110 NO-LOCK:
    CREATE ttCustomer.
    BUFFER-COPY Customer TO ttCustomer.
  END.

  oJsonObject = NEW JsonObject().
  oJsonObject:READ(DATASET dsCustomer:HANDLE).

  lChar = oJsonObject:GetJsonText().
  {&OUT-LONG} lChar.

END PROCEDURE.
