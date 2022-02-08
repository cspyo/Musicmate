import java.awt.Color;
import java.awt.Component;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

import javax.swing.AbstractCellEditor;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.JTextArea;
import javax.swing.JTextField;
import javax.swing.ScrollPaneConstants;
import javax.swing.SwingConstants;
import javax.swing.table.DefaultTableCellRenderer;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.TableCellEditor;
import javax.swing.table.TableCellRenderer;
import javax.swing.table.TableColumn;
import javax.swing.table.TableColumnModel;

public class MainFrame {

	Connection conn; // DB ���� Connection ��ü��������
	JFrame mainFrame;
	JTextField search;
	JTextArea lyrics;
	JButton adminB,searchB, likeB,like2B;
	JLabel likeL;
	PlayListFrame playFrame;
	MainPanel mainPanel;
	JScrollPane mainSC, lyricSC;
	JTable mainT;
	int USER;
	int f_xpos,f_ypos;
	int f_wid = 1000, f_hgt = 800;
	String[] header = {"����","�뷡����","����","����","���"};
	String contents[][];
	String nowAlbum = "none";
	String song;
	DefaultTableModel model;


	MainFrame(int user){
		this.USER = user;
	}

	public void go() {
		dbConnectionInit();
		setUpGUI();

	}
	public void setUpGUI() {
		mainFrame = new JFrame("Musicmate");
		mainFrame.setVisible(true);
		Dimension screen = Toolkit.getDefaultToolkit().getScreenSize();
		f_xpos = (int)(screen.getWidth() / 2 - f_wid/ 2);
		f_ypos = (int)(screen.getHeight() / 2 - f_hgt / 2);

		mainFrame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
		mainFrame.setBounds(f_xpos-150, f_ypos-50, f_wid, f_hgt);

		mainPanel =  new MainPanel();
		mainPanel.setLayout(null);
		mainFrame.getContentPane().add(mainPanel);

		model = new DefaultTableModel(contents,header){
			public boolean isCellEditable(int c, int h) 	// ����Ŭ���� ������ �ȵǰ�
			{
				if(h==0 || h==1 || h==2) return false;
				else return true;
			} 
		};
		mainT = new JTable(model);
		mainSC = new JScrollPane(mainT);
		mainSC.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_ALWAYS); // �����ٻ���
		mainSC.setHorizontalScrollBarPolicy(ScrollPaneConstants.HORIZONTAL_SCROLLBAR_NEVER); // ����ٻ���
		mainT.setAutoResizeMode(JTable.AUTO_RESIZE_OFF);			// Į���� ��������
		mainT.getColumnModel().getColumn(0).setPreferredWidth(40);
		mainT.getColumnModel().getColumn(1).setPreferredWidth(500);
		mainT.getColumnModel().getColumn(2).setPreferredWidth(200);	
		mainT.getColumnModel().getColumn(3).setPreferredWidth(60);
		mainT.getColumnModel().getColumn(4).setPreferredWidth(60); // �������� ��
		mainT.getTableHeader().setResizingAllowed(false);				// ����ڰ� ���� ���� ���ϰԲ�
		mainT.getTableHeader().setReorderingAllowed(false);				// ����ڰ� Į�� ��ġ ���ٲٰ�
		DefaultTableCellRenderer dtcr = new DefaultTableCellRenderer();		// �����͸� ������Ľ�Ű��
		dtcr.setHorizontalAlignment(SwingConstants.CENTER);
		TableColumnModel tcm = mainT.getColumnModel();
		for(int i=0; i< tcm.getColumnCount(); i++) 	tcm.getColumn(i).setCellRenderer(dtcr);		// ������� ��	
		mainT.setRowHeight(40);
		//��ư Į��
		TableColumn buttonColumn1 = mainT.getColumnModel().getColumn(3);
		TableColumn buttonColumn2 = mainT.getColumnModel().getColumn(4);
		InfoButton infoB = new InfoButton();
		PlusButton plusB = new PlusButton();
		buttonColumn1.setCellRenderer(infoB);
		buttonColumn1.setCellEditor(infoB);
		buttonColumn2.setCellRenderer(plusB);
		buttonColumn2.setCellEditor(plusB);
		mainSC.setBounds(50,200, 880, 500);
		prepareList();
		mainPanel.add(mainSC);


		searchB = new JButton("�˻�");
		searchB.setBounds(830, 145, 60, 30);
		search = new JTextField(100);
		search.setBounds(130, 145, 690, 30);
		SearchListener s = new SearchListener();
		searchB.addActionListener(s);
		search.addActionListener(s);
		mainPanel.add(searchB);
		mainPanel.add(search);


		if(USER ==1) {
			adminB = new JButton("�����ڸ��");
			adminB.setBounds(840, 10, 105, 43);
			adminB.addActionListener(new AdminListener());
			mainPanel.add(adminB);
		}

		mainPanel.repaint();
		playFrame = new PlayListFrame(USER);		
	}

	//DB���� �޼ҵ�
	private void dbConnectionInit() 			 
	{
		try 
		{
			Class.forName("com.mysql.cj.jdbc.Driver");					// JDBC����̹��� JVM�������� ��������
			conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/musicmate?serverTimezone=Asia/Seoul&useSSL=false", "root", "487875");	// DB �����ϱ�
			System.out.println("����Ǿ����ϴ�");
		}
		catch (ClassNotFoundException cnfe) 
		{
			System.out.println("JDBC ����̹� Ŭ������ ã�� �� �����ϴ� : " + cnfe.getMessage());
		}
		catch (Exception ex) 
		{
			System.out.println("DB ���� ���� : " + ex.getMessage());
		}
	}



	//�������̺� ����Ʈ
	public void prepareList() 
	{
		try 
		{
			Statement stmt = conn.createStatement();			// SQL ���� �ۼ��� ����  Statement ��ü ����
			// ���� DB�� �ִ� ���� �����ؼ� �뷡����� songs ����Ʈ�� ����ϱ�
			ResultSet rs = stmt.executeQuery("SELECT m.����, s.���� FROM music m NATURAL JOIN singers s order by ���ƿ� desc");
			String nameis,singeris,chartis;
			String[] move = new String[3];
			int rank =0;
			while (rs.next()) 
			{
				rank++;
				chartis = String.valueOf(rank);
				nameis = rs.getString("����");
				singeris = rs.getString("����");
				model.addRow(new Object[] {chartis,nameis,singeris,"����","���" });
			}
			stmt.close();										// statement�� ����� �ݴ� ����
		} catch (SQLException sqlex) 
		{
			System.out.println("SQL ���� : " + sqlex.getMessage());
			sqlex.printStackTrace();
		}
	}

	void info(int row) {
		song = (String)model.getValueAt(row, 1);
		//nowAlbum = song;
		JFrame infoFrame = new JFrame(song+" ����");
		infoFrame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
		infoFrame.setBounds(f_xpos+200, f_ypos+50, 500, 600);
		infoFrame.setVisible(true);

		InfoPanel infoPanel = new InfoPanel();
		infoPanel.setLayout(null);
		infoFrame.getContentPane().add(infoPanel);

		String lyric = "";
		String singer = "", date = "", genre = "";
		int like=0;
		try 
		{
			Statement stmt = conn.createStatement();			// SQL ���� �ۼ��� ����  Statement ��ü ����
			ResultSet rs = stmt.executeQuery("SELECT l.����,s.����,m.�߸���,g.�帣, m.���ƿ�  FROM music m NATURAL JOIN lyrics l natural join singers s natural join genre g where m.����='"+song+"';");
			rs.next();
			lyric = rs.getString("l.����");
			singer = rs.getString("s.����");
			date = rs.getString("m.�߸���");
			genre = rs.getString("g.�帣");
			like = rs.getInt("m.���ƿ�");
			stmt.close();										// statement�� ����� �ݴ� ����
		} catch (SQLException sqlex) 
		{
			System.out.println("SQL ���� : " + sqlex.getMessage());
			sqlex.printStackTrace();
		}

		lyrics = new JTextArea(lyric,50,50);
		lyrics.setEditable(false);
		lyricSC = new JScrollPane(lyrics);
		lyricSC.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_ALWAYS); // �����ٻ���
		lyricSC.setHorizontalScrollBarPolicy(ScrollPaneConstants.HORIZONTAL_SCROLLBAR_NEVER); // ����ٻ���
		lyricSC.setBounds(15, 250, 450, 300);
		infoPanel.add(lyricSC);

		JLabel songL = new JLabel("���� : " +song);
		JLabel singerL = new JLabel("���� : "+singer);
		JLabel dateL = new JLabel("�߸��� : "+date);
		JLabel genreL = new JLabel("�帣 : "+genre);
		likeL = new JLabel(""+like);
		songL.setBounds(220, 60, 200, 50);
		singerL.setBounds(220, 80, 200, 50);
		dateL.setBounds(220, 100, 200, 50);
		genreL.setBounds(220, 120, 200, 50);
		likeL.setBounds(260, 140, 70, 70);

		likeB = new JButton(new ImageIcon("src/Image/like.png"));
		like2B = new JButton(new ImageIcon("src/Image/like2.png"));
		likeB.setBounds(210, 150, 50, 50);
		like2B.setBounds(210, 150, 50, 50);
		likeB.setBorderPainted(false);likeB.setFocusPainted(false);likeB.setContentAreaFilled(false);
		like2B.setBorderPainted(false);like2B.setFocusPainted(false);like2B.setContentAreaFilled(false);
		likeB.setVisible(false);
		likeB.addActionListener(new LikeListener());
		like2B.addActionListener(new LikeListener2());

		infoPanel.add(songL);
		infoPanel.add(singerL);
		infoPanel.add(dateL);
		infoPanel.add(genreL);
		infoPanel.add(likeL);
		infoPanel.add(likeB);
		infoPanel.add(like2B);

	}

	//�����г�
	class MainPanel extends JPanel{
		public void paintComponent(Graphics g) {
			Graphics2D g2d = (Graphics2D) g;
			g2d.setColor(Color.WHITE);
			g2d.fillRect(0, 0, f_wid, f_hgt);
			ImageIcon musicmate = new ImageIcon("src/Image/musicmate2.png");
			g2d.drawImage(musicmate.getImage(), 200,5, 600, 100, this);
			ImageIcon search = new ImageIcon("src/Image/search.png");
			g2d.drawImage(search.getImage(), 75,135, 50, 50, this);
		}
	}

	class InfoPanel extends JPanel{
		public void paintComponent(Graphics g) {
			Graphics2D g2d = (Graphics2D) g;
			ImageIcon back = new ImageIcon("src/Image/info���.png");
			g2d.drawImage(back.getImage(),-10,0, 500, 600, this);
			ImageIcon asd = new ImageIcon("src/album/"+nowAlbum+".png");
			g2d.drawImage(asd.getImage(),50,55, 150, 150, this);
		}
	}

	class LikeListener implements ActionListener{
		@Override
		public void actionPerformed(ActionEvent e) {
			int like=0;
			try 
			{
				Statement stmt = conn.createStatement();			// SQL ���� �ۼ��� ����  Statement ��ü ����
				stmt.executeUpdate("UPDATE music SET ���ƿ� = ���ƿ�-1 WHERE ����='"+song+"';");
				ResultSet rs = stmt.executeQuery("SELECT ���ƿ� from music where ����='"+song+"';");
				rs.next();
				like = rs.getInt("���ƿ�");
				stmt.close();										// statement�� ����� �ݴ� ����
			} catch (SQLException sqlex) 
			{
				System.out.println("SQL ���� : " + sqlex.getMessage());
				sqlex.printStackTrace();
			}
			likeL.setText(""+like);
			likeB.setVisible(false);
			like2B.setVisible(true);
		}

	}
	class LikeListener2 implements ActionListener{

		@Override
		public void actionPerformed(ActionEvent e) {
			int like=0;
			try 
			{
				Statement stmt = conn.createStatement();			// SQL ���� �ۼ��� ����  Statement ��ü ����
				stmt.executeUpdate("UPDATE music SET ���ƿ� = ���ƿ�+1 WHERE ����='"+song+"';");
				ResultSet rs = stmt.executeQuery("SELECT ���ƿ� from music where ����='"+song+"';");
				rs.next();
				like = rs.getInt("���ƿ�");
				stmt.close();										// statement�� ����� �ݴ� ����
			} catch (SQLException sqlex) 
			{
				System.out.println("SQL ���� : " + sqlex.getMessage());
				sqlex.printStackTrace();
			}
			likeL.setText(""+like);
			likeB.setVisible(true);
			like2B.setVisible(false);

		}

	}

	class SearchListener implements ActionListener{
		@Override
		public void actionPerformed(ActionEvent e) {
			String whatSearch = search.getText();
			if(whatSearch.compareTo("") == 0) {
				prepareList();
				return;
			}
			DefaultTableModel asd = (DefaultTableModel)mainT.getModel();
			asd.setNumRows(0);
			try 
			{
				Statement stmt = conn.createStatement();			// SQL ���� �ۼ��� ����  Statement ��ü ����
				// ���� DB�� �ִ� ���� �����ؼ� �뷡����� songs ����Ʈ�� ����ϱ�
				ResultSet rs = stmt.executeQuery("SELECT m.����, s.���� FROM music m NATURAL JOIN singers s  WHERE m.���� LIKE '%"
						+whatSearch+"%' order by ���ƿ� desc;");
				String nameis,singeris,chartis;
				String[] move = new String[3];
				int rank =0;
				while (rs.next()) 
				{
					rank++;
					chartis = String.valueOf(rank);
					nameis = rs.getString("����");
					singeris = rs.getString("����");
					model.addRow(new Object[] {chartis,nameis,singeris,"����","���" });
				}
				stmt.close();										// statement�� ����� �ݴ� ����
			} catch (SQLException sqlex) 
			{
				System.out.println("SQL ���� : " + sqlex.getMessage());
				sqlex.printStackTrace();
			}
		}
	}
	class AdminListener implements ActionListener{
		@Override
		public void actionPerformed(ActionEvent e) {
			// DB���� �������� �����͸� rowObjects�� ���·� �����ϰ� �̵��� ����Ʈ�� Printer �Ǵ� Preview�� ���� ��
			ArrayList<RowObjects> rowList = new ArrayList<RowObjects>();	// ����� ����Ʈ
			RowObjects line;												// �ϳ��� ��
			PrintObject word;												// �ϳ��� �ܾ�
			try {
				Statement stmt = conn.createStatement();					// SQL ���� ����� ���� Statement ��ü
				ResultSet rs = stmt.executeQuery("SELECT ȸ����ȣ, �̸�, ���̵�, ��й�ȣ, g.�帣 FROM user natural join genre g");
				while(rs.next()) {
					line = new RowObjects();								// 5���� �ܾ 1��
					line.add(new PrintObject(rs.getString("ȸ����ȣ"), 10));
					line.add(new PrintObject(rs.getString("�̸�"), 10));
					line.add(new PrintObject(rs.getString("���̵�"), 20));
					line.add(new PrintObject(rs.getString("��й�ȣ"), 20));
					line.add(new PrintObject(rs.getString("g.�帣"), 10));
					rowList.add(line);										// ����ؾ� �� ��ü ����Ʈ�� ����									
				}
				
				stmt.close();

				// �� �������� Į�� ����� ���� �� �� ������
				line = new RowObjects();									// 5���� �ܾ 1��
				line.add(new PrintObject("ȸ����ȣ", 10));
				line.add(new PrintObject("�̸�", 10));
				line.add(new PrintObject("���̵�", 20));
				line.add(new PrintObject("��й�ȣ", 20));
				line.add(new PrintObject("�帣", 10));



				Preview prv = new Preview(new PrintObject("ȸ������Ʈ", 20), line, rowList, true);
				prv.preview();

			} catch (SQLException sqlex) {
				System.out.println("SQL ���� : " + sqlex.getMessage());
				sqlex.printStackTrace();
			} catch (Exception ex) {
				System.out.println("DB Handling ����(����Ʈ ������) : " + ex.getMessage());
				ex.printStackTrace();
			}
		}



	}
	//���̺� ��ư���
	//������ư
	class InfoButton extends AbstractCellEditor implements TableCellEditor, TableCellRenderer
	{
		public Component getTableCellRendererComponent(JTable table, Object value, boolean selected, boolean focus, final int row, final int column)
		{
			JButton button = null;
			button = new JButton(new ImageIcon("src/Image/infoO.png"));
			button.setBorderPainted(false);button.setFocusPainted(false);button.setContentAreaFilled(false);

			button.addActionListener(new ActionListener()
			{
				public void actionPerformed(ActionEvent e)
				{
					System.out.println(model.getValueAt(row, 1));
				}
			});
			return button;
		}
		public Component getTableCellEditorComponent(JTable table, Object value, boolean selected, int row, int column)
		{
			JButton button = null;

			button = new JButton(new ImageIcon("src/Image/infoO.png"));
			button.setBorderPainted(false);button.setFocusPainted(false);button.setContentAreaFilled(false);
			button.addActionListener(new ActionListener()
			{
				public void actionPerformed(ActionEvent e)
				{
					info(row);
				}
			});

			return button;
		}
		@Override
		public Object getCellEditorValue() {
			// TODO Auto-generated method stub
			return null;
		}
	}
	//��� ��ư
	class PlusButton extends AbstractCellEditor implements TableCellEditor, TableCellRenderer
	{
		public Component getTableCellRendererComponent(JTable table, Object value, boolean selected, boolean focus, final int row, final int column)
		{
			JButton button = null;

			{
				button = new JButton(new ImageIcon("src/Image/addB.png"));
				button.setBorderPainted(false);button.setFocusPainted(false);button.setContentAreaFilled(false);
				button.addActionListener(new ActionListener()
				{
					public void actionPerformed(ActionEvent e)
					{

					}
				}); 
			}
			return button;
		}
		public Component getTableCellEditorComponent(JTable table, Object value, boolean selected, int row, int column)
		{
			JButton button = null;
			{
				button = new JButton(new ImageIcon("src/Image/addB.png"));
				button.setBorderPainted(false);button.setFocusPainted(false);button.setContentAreaFilled(false);
				button.addActionListener(new ActionListener()
				{
					public void actionPerformed(ActionEvent e)
					{
						try 
						{
							String a = (String)model.getValueAt(row, 1);
							Statement stmt = conn.createStatement();			
							stmt.executeUpdate("INSERT INTO playlist"+USER+"(�뷡��ȣ) SELECT �뷡��ȣ FROM music WHERE ����='"+a+"';");
							stmt.close();										// statement�� ����� �ݴ� ����
							playFrame.prepareList();
						} catch (SQLException sqlex) 
						{
							System.out.println("SQL ���� : " + sqlex.getMessage());
							sqlex.printStackTrace();
						}
					}
				});
			}
			return button;
		}
		@Override
		public Object getCellEditorValue() {
			return null;
		}
	}
}

