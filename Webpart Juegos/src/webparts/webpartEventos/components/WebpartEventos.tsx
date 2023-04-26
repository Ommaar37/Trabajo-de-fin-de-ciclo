import * as React from "react";
import { Calendar, momentLocalizer } from "react-big-calendar";
import * as moment from "moment";
import "react-big-calendar/lib/css/react-big-calendar.css";
import { WebPartContext } from "@microsoft/sp-webpart-base";
import { SPFI } from "@pnp/sp";

// Define la interfaz de un evento
interface Evento {
  Title: string;
  E_Juego: string;
  E_Fech: string;
  E_Inicio: string;
  E_Fin: string;
  E_Desc: string;
}

export interface IWebpartEventosProps {
  description: string;
  isDarkTheme: boolean;
  environmentMessage: string;
  hasTeamsContext: boolean;
  userDisplayName: string;
  SP: SPFI;
  WebPartContext: WebPartContext;
}

export default function Eventos(props: IWebpartEventosProps) {
  const [datos, setDatos] = React.useState<Evento[]>([]);

  React.useEffect(() => {
    cargarDatos();
  }, []);

  const cargarDatos = async function () {
    const lista = await props.SP.web.lists.getByTitle("Eventos");
    const eventos = await lista.items.top(5000).select("*")();

    let filas = [];
    eventos.map((e: any) => {
      filas.push({
        'Title': e.Title,
        'E_Nombre': e.E_Nombre,
        'E_Fech': e.E_Fech,
        'E_Inicio': e.E_Inicio,
        'E_Fin': e.E_Fin,
        'E_Desc': e.E_Desc
      })
    })
    setDatos(eventos);
  }

  // Crea una lista de objetos que representen cada evento
  const listaEventos = datos.map((evento) => ({
    title: evento.Title,
    start: new Date(evento.E_Fech + 'T' + evento.E_Inicio),
    end: new Date(evento.E_Fech + 'T' + evento.E_Fin),
    desc: evento.E_Desc
  }));

  const localizer = momentLocalizer(moment);

  return (
    <div className="App">
      <Calendar
        localizer={localizer}
        events={listaEventos}
        startAccessor="start"
        endAccessor="end"
        style={{ height: 500 }}
      />
    </div>
  );
}
