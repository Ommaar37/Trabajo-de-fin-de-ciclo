/// <reference types="react" />
import { WebPartContext } from "@microsoft/sp-webpart-base";
import { SPFI } from "@pnp/sp";
interface JuegoItem {
    Title: string;
    J_Desc: string;
    J_Dur: string;
    J_Gen: string;
    J_Lanz: string;
}
export interface DataType {
    key: string;
    item: JuegoItem;
}
export interface IWebpart1Props {
    description: string;
    isDarkTheme: boolean;
    environmentMessage: string;
    hasTeamsContext: boolean;
    userDisplayName: string;
    SP: SPFI;
    WebPartContext: WebPartContext;
}
export default function HelloWorld(props: IWebpart1Props): JSX.Element;
export {};
//# sourceMappingURL=Webpart1.d.ts.map