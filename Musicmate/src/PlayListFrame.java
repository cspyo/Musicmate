import java.awt.Color;
import java.awt.Component;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.swing.AbstractCellEditor;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.ListSelectionModel;
import javax.swing.ScrollPaneConstants;
import javax.swing.SwingConstants;
import javax.swing.table.DefaultTableCellRenderer;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.TableCellEditor;
import javax.swing.table.TableCellRenderer;
import javax.swing.table.TableColumn;
import javax.swing.table.TableColumnModel;

import javazoom.jl.decoder.JavaLayerException;
import javazoom.jl.player.advanced.AdvancedPlayer;
import javazoom.jl.player.advanced.PlaybackEvent;
import javazoom.jl.player.advanced.PlaybackListener;



public class PlayListFrame {
	int USER;
	JFrame playFrame;
	MainPanel2 panel;
	JTable myT;
	JScrollPane mySC;
	JButton playB, pauseB, nextB, previousB,stopB,resumeB;
	JLabel song, singer;
	String[] header = {"노래제목","가수","삭제"};
	String contents[][];
	DefaultTableModel pModel;
	Connection conn;
	String nowPlaying;
	String nowAlbum = "none";
	int myIndex=0, musicLength,wherePause;
	String musicAddress = "src/music/";
	FileInputStream musicFIS;
	BufferedInputStream musicBIS;
	public AdvancedPlayer player = null;

	PlayListFrame(int user){
		USER = user;
		dbConnectionInit();
		setUpGUI();
	}

	private void dbConnectionInit() 			 
	{
		try 
		{
			Class.forName("com.mysql.cj.jdbc.Driver");					// JDBC드라이버를 JVM영역으로 가져오기
			conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/musicmate?serverTimezone=Asia/Seoul&useSSL=false", "root", "487875");	// DB 연결하기
			System.out.println("연결되었습니다");
		}
		catch (ClassNotFoundException cnfe) 
		{
			System.out.println("JDBC 드라이버 클래스를 찾을 수 없습니다 : " + cnfe.getMessage());
		}
		catch (Exception ex) 
		{
			System.out.println("DB 연결 에러 : " + ex.getMessage());
		}
	}

	void setUpGUI() {
		playFrame = new JFrame("플레이리스트");
		playFrame.setBounds(460+850, 140-50,450, 800);
		playFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		playFrame.setVisible(true);

		panel = new MainPanel2();
		panel.setLayout(null);
		playFrame.getContentPane().add(panel);

		playB = new JButton(new ImageIcon("src/Image/playB.png"));
		pauseB = new JButton(new ImageIcon("src/Image/pauseB.png"));
		stopB = new JButton(new ImageIcon("src/Image/stopB.png"));
		nextB = new JButton(new ImageIcon("src/Image/nextB.png"));
		previousB = new JButton(new ImageIcon("src/Image/previousB.png"));
		resumeB = new JButton(new ImageIcon("src/Image/resumeB.png"));
		resumeB.setBounds(150, 200, 60, 60);
		playB.setBounds(230, 200, 60, 60);
		pauseB.setBounds(150, 200, 60, 60);
		stopB.setBounds(230, 200, 60, 60);
		nextB.setBounds(300, 205, 50, 50);
		previousB.setBounds(90, 205, 50, 50);
		resumeB.setBorderPainted(false);resumeB.setFocusPainted(false);resumeB.setContentAreaFilled(false);
		playB.setBorderPainted(false);playB.setFocusPainted(false);playB.setContentAreaFilled(false);
		pauseB.setBorderPainted(false);pauseB.setFocusPainted(false);pauseB.setContentAreaFilled(false);
		nextB.setBorderPainted(false);nextB.setFocusPainted(false);nextB.setContentAreaFilled(false);
		previousB.setBorderPainted(false);previousB.setFocusPainted(false);previousB.setContentAreaFilled(false);
		stopB.setBorderPainted(false);stopB.setFocusPainted(false);stopB.setContentAreaFilled(false);
		playB.addActionListener(new PlayListener());
		pauseB.addActionListener(new PauseListener());
		resumeB.addActionListener(new ResumeListener());
		stopB.addActionListener(new StopListener());
		nextB.addActionListener(new nextListener());
		previousB.addActionListener(new previousListener());
		panel.add(pauseB);
		panel.add(resumeB);
		panel.add(stopB);
		panel.add(playB);
		panel.add(nextB);
		panel.add(previousB);
		resumeB.setVisible(false);
		stopB.setVisible(false);

		song = new JLabel("제목");
		song.setBounds(210, 20, 200, 60);
		singer = new JLabel("가수");
		singer.setBounds(210, 70, 200, 60);
		
		panel.add(song);
		panel.add(singer);
		
		pModel = new DefaultTableModel(contents,header){
			public boolean isCellEditable(int c, int h) 	// 더블클릭시 수정이 안되게
			{
				if(h==0 || h==1) {
					return false;
				}
				else
					return true;
			} 
		};
		myT = new JTable(pModel);
		mySC = new JScrollPane(myT);
		mySC.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_ALWAYS); // 수직바생성
		mySC.setHorizontalScrollBarPolicy(ScrollPaneConstants.HORIZONTAL_SCROLLBAR_NEVER); // 수평바생성
		mySC.setOpaque(false);
		mySC.getViewport().setOpaque(false);
		myT.setOpaque(false);
		myT.setAutoResizeMode(JTable.AUTO_RESIZE_OFF);			// 칼럼들 길이조절
		myT.getColumnModel().getColumn(0).setPreferredWidth(210);
		myT.getColumnModel().getColumn(1).setPreferredWidth(110);
		myT.getColumnModel().getColumn(2).setPreferredWidth(65);
		TableColumn buttonColumn1 = myT.getColumnModel().getColumn(2);
		DeleteButton deleteB = new DeleteButton();
		buttonColumn1.setCellRenderer(deleteB);
		buttonColumn1.setCellEditor(deleteB);
		myT.getTableHeader().setResizingAllowed(false);				// 사용자가 길이 조정 못하게끔
		myT.getTableHeader().setReorderingAllowed(false);				// 사용자가 칼럼 위치 못바꾸게
		DefaultTableCellRenderer dtcr = new DefaultTableCellRenderer();		// 데이터를 가운데정렬시키기
		dtcr.setHorizontalAlignment(SwingConstants.CENTER);
		TableColumnModel tcm = myT.getColumnModel();
		for(int i=0; i< tcm.getColumnCount(); i++) 	tcm.getColumn(i).setCellRenderer(dtcr);		// 가운데정렬 끝	
		myT.setRowHeight(40);
		myT.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
		mySC.setBounds(15, 300, 405, 400);
		prepareList();
		panel.add(mySC);

		panel.repaint();
	}
	public void prepareList() {
		DefaultTableModel asd = (DefaultTableModel)myT.getModel();
		asd.setNumRows(0);

		try 
		{
			//pModel.getDataVector().removeAllElements();
			Statement stmt = conn.createStatement();			
			ResultSet rs = stmt.executeQuery("SELECT m.제목, s.가수 FROM music m NATURAL JOIN singers s NATURAL JOIN playlist"+USER+" order by 순서;");
			String nameis,singeris;
			while (rs.next()) 
			{
				nameis = rs.getString("제목");
				singeris = rs.getString("가수");
				pModel.addRow(new Object[] {nameis,singeris});
			}

			stmt.close();										// statement는 사용후 닫는 습관
		} catch (SQLException sqlex) 
		{
			System.out.println("SQL 에러 : " + sqlex.getMessage());
			sqlex.printStackTrace();
		}
	}


	//패널
	class MainPanel2 extends JPanel{
		public void paintComponent(Graphics g) {
			Graphics2D g2d = (Graphics2D) g;
			g2d.setColor(Color.WHITE);
			g2d.fillRect(0, 0, 450, 800);
			ImageIcon back = new ImageIcon("src/Image/배경.png");
			g2d.drawImage(back.getImage(), 10, 5, 415, 280, this);
			ImageIcon album = new ImageIcon("src/album/"+nowAlbum+".png");
			g2d.drawImage(album.getImage(),45,30,150,150,this);
		}
	}
	
	public void play() {
		nowPlaying = (String)pModel.getValueAt(myIndex, 0);
		resumeB.setVisible(false);
		pauseB.setVisible(true);
		stopB.setVisible(true);
		playB.setVisible(false);
		song.setText(nowPlaying);
		singer.setText((String)pModel.getValueAt(myIndex, 1));
		//nowAlbum = nowPlaying;
		myT.setRowSelectionInterval(myIndex, myIndex);
		try
		{
			musicFIS = new FileInputStream("src/music/"+nowPlaying+".mp3");
			musicBIS = new BufferedInputStream(musicFIS);
			player = new AdvancedPlayer(musicBIS);
			player.setPlayBackListener(new ControlListener());		// 노래가끝나도 다음곡으로넘어가게끔
			musicLength = musicFIS.available();
			new Thread()			
			{
				public void run()
				{
					try
					{
						player.play();
					}
					catch(JavaLayerException ex){}
				}
			}.start();
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
		}
		
	}
	
	class PlayListener implements ActionListener
	{
		public void actionPerformed (ActionEvent e) 
		{
			int a = myT.getSelectedRow();
			if(a ==-1) 
				myIndex = 0;
			else 
				myIndex = a;
			
			play();
		}
	}
	
	class PauseListener implements ActionListener 
	{
		public void actionPerformed (ActionEvent e) 
		{
			if(player!=null) 
			{
				try 
				{
					wherePause = musicFIS.available();
					player.close();
				} 
				catch (IOException e1) 
				{
					e1.printStackTrace();
				}
				pauseB.setVisible(false);
				resumeB.setVisible(true);
			}

		}
	}

	class ResumeListener implements ActionListener
	{
		public void actionPerformed (ActionEvent e) 
		{

			resumeB.setVisible(false);
			pauseB.setVisible(true);
			try
			{
				musicFIS = new FileInputStream(musicAddress+nowPlaying+".mp3");
				musicBIS = new BufferedInputStream(musicFIS);
				player = new AdvancedPlayer(musicBIS);
				player.setPlayBackListener(new ControlListener());		// 노래가끝나도 다음곡으로넘어가게끔
				musicFIS.skip(musicLength - wherePause);
				new Thread()			
				{
					public void run()
					{
						try
						{
							player.play();
							sleep(5000);
						}
						catch(JavaLayerException ex){} 
						catch (InterruptedException e) {
							e.printStackTrace();
						}
					}
				}.start();
			}
			catch(Exception ex)
			{
				ex.printStackTrace();
			}
			

		}
	}
	class StopListener implements ActionListener{
		public void actionPerformed (ActionEvent e) 
		{
			if(player!=null) 
			{
				try 
				{
					player.close();
				} 
				catch (Exception e1) 
				{
					e1.printStackTrace();
				}
			}
			wherePause = 0;
			player = null;
			pauseB.setVisible(true);
			resumeB.setVisible(false);
			stopB.setVisible(false);
			playB.setVisible(true);
		}
	}
	class previousListener implements ActionListener{
		public void actionPerformed (ActionEvent e) {
			myIndex--;
			stopB.doClick();
			if(myIndex >= 0) {
				
				play();
			}
			else {
				myIndex = myT.getRowCount()-1;
				play();
			}
		}
	}
	class nextListener implements ActionListener{
		public void actionPerformed (ActionEvent e) {
			myIndex++;
			stopB.doClick();
			if(myIndex < myT.getRowCount()) {
				play();
			}
			else {
				myIndex = 0;
				play();
			}
		}
	}

	//삭제버튼
	class DeleteButton extends AbstractCellEditor implements TableCellEditor, TableCellRenderer
	{
		public Component getTableCellRendererComponent(JTable table, Object value, boolean selected, boolean focus, final int row, final int column)
		{
			JButton button = null;
			button = new JButton(new ImageIcon("src/Image/deleteB.png"));
			button.setBorderPainted(false);button.setFocusPainted(false);button.setContentAreaFilled(false);
			button.setVisible(true);
			button.addActionListener(new ActionListener()
			{
				public void actionPerformed(ActionEvent e)
				{

				}
			}); 

			return button;
		}
		public Component getTableCellEditorComponent(JTable table, Object value, boolean selected, int row, int column)
		{
			JButton button = null;
			button = new JButton(new ImageIcon("src/Image/deleteB.png"));
			button.setBorderPainted(false);button.setFocusPainted(false);button.setContentAreaFilled(false);
			button.setVisible(true);
			button.addActionListener(new ActionListener()
			{
				public void actionPerformed(ActionEvent e)
				{
					try 
					{
						String a= (String)pModel.getValueAt(row, 0);
						prepareList();
						Statement stmt = conn.createStatement();			
						stmt.executeUpdate("DELETE FROM playlist"+USER+" WHERE 노래번호 = (SELECT 노래번호 FROM music WHERE 제목 = '"+a+"');");
						stmt.close();
						prepareList();
					} catch (SQLException sqlex) 
					{
						System.out.println("SQL 에러 : " + sqlex.getMessage());
						sqlex.printStackTrace();
					}
				}
			});

			return button;
		}
		@Override
		public Object getCellEditorValue() {
			return null;
		}
	}

	public class ControlListener extends PlaybackListener
	{
		public void playbackStarted(PlaybackEvent evt) 	{}
		public void playbackFinished(PlaybackEvent evt) 
		{
			nextB.doClick();
		}
	}
}
